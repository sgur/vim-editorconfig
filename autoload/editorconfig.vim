scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:editorconfig = '.editorconfig'

function! editorconfig#load(path)
  call s:apply(a:path)
endfunction

function! s:scan(path)
  let editorconfig = findfile(s:editorconfig, fnameescape(a:path) . ';')
  if empty(editorconfig) || !filereadable(editorconfig) || a:path is# fnamemodify(a:path, ':h')
    return []
  endif
  let _ = []
  let base_path = fnamemodify(editorconfig, ':p:h')
  let [is_root, _] = s:parse(s:trim(readfile(editorconfig)), base_path)
  if is_root
    call s:set_cwd(base_path)
    return _
  endif
  return _ + s:scan(fnamemodify(base_path, ':h'))
endfunction

function! s:parse(lines, dir)
  let [unparsed, is_root] = s:parse_properties(a:lines)
  let _ = []
  while len(unparsed) > 0
    let [unparsed, pattern] = s:parse_pattern(unparsed)
    let [unparsed, properties] = s:parse_properties(unparsed)
    let _ += [[pattern, properties]]
  endwhile
  return [get(is_root, 'root', 'false') == 'true', _]
endfunction

function! s:parse_pattern(lines)
  if !len(a:lines) | return [[], ''] |endif
  let m = matchstr(a:lines[0], '^\[\zs.\+\ze\]$')
  if !empty(m)
    return [a:lines[1 :], m]
  else
    return [a:lines, '_']
  endif
endfunction

function! s:parse_properties(lines)
  let _ = {}
  if !len(a:lines) | return [[], _] | endif
  for i in range(len(a:lines))
    let line = a:lines[i]
    let m = matchstr(line, '^\[\zs.\+\ze\]$')
    if !empty(m)
      return [a:lines[i :], _]
    endif
    let [key, val] = split(line, '\s*=\s*')
    let _[key] = s:eval(val)
  endfor
  return [a:lines[i+1 :], _]
endfunction

function! s:eval(val)
  return type(a:val) == type('') && a:val =~# '^\d\+$' ? eval(a:val) : a:val
endfunction

function! s:trim(lines)
  return filter(map(a:lines, 's:remove_comment(v:val)'), '!empty(v:val)')
endfunction

function! s:remove_comment(line)
  let pos = match(a:line, '[;#].\+')
  return pos == -1 ? a:line : pos == 0 ? '' : a:line[: pos-1]
endfunction

function! s:set_cwd(dir)
  if g:editorconfig_root_chdir
    lcd `=a:dir`
  endif
endfunction

function! s:apply(path)
  let path = fnamemodify(a:path, ':p')
  let config = s:scan(fnamemodify(path, ':h'))
  let b:editorconfig = s:filter_matched(path, config)
  call s:invoke_commands(b:editorconfig)
endfunction

function! s:invoke_commands(property)
  for cmd in s:prop2cmds(a:property)
    execute cmd
  endfor
endfunction

function! s:filter_matched(path, properties)
  let _ = {}
  for p in filter(copy(a:properties), 'a:path =~ s:regexp(v:val[0])')
    call extend(_, p[1], "keep")
  endfor
  return _
endfunction

function! s:prop2cmds(properties)
  let _ = []
  for [key, val] in items(a:properties)
    try
      let _ += s:property_{key}(val)
    catch /.*/
      echomsg v:exception
      echomsg v:throwpoint
    endtry
  endfor
  return _
endfunction

function! s:regexp(pattern)
  if a:pattern is# '_'
    return '^.*$'
  endif
  let pattern = escape(a:pattern, '.\')
  let pattern = substitute(pattern, '\[!', '[^', 'g')
  let pattern = substitute(pattern, '{\(\f\+\),\(\f\+\)}' ,'\\%(\1\\|\2\\)', 'g')
  let pattern = substitute(pattern, '\*\{2}', '.\\{}', 'g')
  let pattern = substitute(pattern, '\(\.\)\@<!\*', '[^\\/]\\{}', 'g')
  return pattern . '$'
endfunction

function! s:property_indent_style(value)
  try
    return s:indent_style[a:value]
  catch /^Vim\%((\a\+)\)\=:E716/
    echoerr printf('editorconfig: unsupported value: indent_style=%s', a:value)
    return []
  endtry
endfunction
let s:indent_style =
      \ { 'tab': ['setlocal expandtab']
      \ , 'space': ['setlocal noexpandtab']
      \ }

function! s:property_indent_size(value)
  " [:digit:]+ or 'tab'
  if type(a:value) == type(0)
    return ['setlocal shiftwidth=' . a:value]
  elseif a:value is# 'tab'
    return ['setlocal shiftwidth=0']
  endif
  echoerr printf('editorconfig: unsupported value: indent_size=%s', a:value)
  return []
endfunction

function! s:property_tab_width(value)
  " [:digit:]+
  if type(a:value) == type(0)
    return ['setlocal tabstop=' . a:value]
  endif
  echoerr printf('editorconfig: unsupported value: tab_width=%s', a:value)
  return []
endfunction

function! s:property_end_of_line(value)
  try
    return s:end_of_line[tolower(a:value)]
  catch /^Vim\%((\a\+)\)\=:E716/
    echoerr printf('editorconfig: unsupported value: end_of_line=%s', a:value)
    return []
  endtry
endfunction
let s:end_of_line =
      \ { 'lf': ['setlocal fileformat=unix']
      \ , 'cr': ['setlocal fileformat=mac']
      \ , 'crlf': ['setlocal fileformat=dos']
      \ }

function! s:property_charset(value)
  " encoding
  try
    return ['setlocal fileencoding=' . a:value]
  endtry
  echoerr printf('editorconfig: unsupported value: charset=%s', a:value)
  return []
endfunction

function! s:property_trim_trailing_whitespace(value)
  " 'true' or 'false'
  if a:value == 'true'
    return ['autocmd BufWritePre <buffer> %s/\s\+$//e']
  elseif a:value== 'false'
    return []
  endif
  echoerr printf('editroconfig: unsupported value: trim_trailing_whitespace=%s', a:value)
  return []
endfunction

function! s:property_insert_final_newline(value)
  " 'true' or 'false'
  if a:value == 'true'
    return []
  elseif a:value== 'false'
    let eol = &endofline
    let bin = &binary
    return
	  \ [ 'autocmd BufWritePre <buffer> setlocal noendofline binary'
     \ , printf('autocmd BufWritePost <buffer> setlocal %sendofline %sbinary', eol ? '' : 'no', bin ? '' : 'no')
	  \ ]
  endif
  echoerr printf('editroconfig: unsupported value: insert_final_newline=%s', a:value)
  return []
endfunction

function! s:property_max_line_length(value)
  " number
  if type(a:value) == type(0)
    return ['setlocal fileencoding=' . a:value]
  endif
  echoerr printf('editroconfig: unsupported value: max_line_length=%s', a:value)
  return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
