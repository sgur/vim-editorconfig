scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:editorconfig = '.editorconfig'

let s:scriptdir = expand('<sfile>:p:r')

" {{{1 Interfaces
function! editorconfig#load(path) "{{{
  augroup plugin-editorconfig-local
    autocmd!
  augroup END
  let filepath = fnamemodify(a:path, ':p')
  let props = s:filter_matched(s:scan(fnamemodify(filepath, ':h')), filepath)
  if empty(props) | return | endif
  call s:apply(props)
endfunction "}}}

function! editorconfig#omnifunc(findstart, base) "{{{
  if a:findstart
    let pos = match(getline('.'), '\%' . col('.') . 'c\k\+\zs\s*=')
    return pos+1
  else
    return filter(sort(s:properties()), 'stridx(v:val, a:base) == 0')
  endif
endfunction "}}}

" {{{1 Inner functions
function! s:scan(path) "{{{
  let editorconfig = findfile(s:editorconfig, fnameescape(a:path) . ';')
  if empty(editorconfig) || !filereadable(editorconfig) || a:path is# fnamemodify(a:path, ':h')
    return []
  endif
  let base_path = fnamemodify(editorconfig, ':p:h')
  let [is_root, _] = s:parse(s:trim(readfile(editorconfig)), base_path)
  if is_root
    call s:set_cwd(base_path)
    return _
  endif
  return _ + s:scan(fnamemodify(base_path, ':h'))
endfunction "}}}

function! s:parse(lines, dir) "{{{
  let [unparsed, is_root] = s:parse_properties(a:lines)
  let _ = []
  while len(unparsed) > 0
    let [unparsed, pattern] = s:parse_pattern(unparsed)
    let [unparsed, properties] = s:parse_properties(unparsed)
    let _ += [[pattern, properties]]
  endwhile
  return [get(is_root, 'root', 'false') == 'true', _]
endfunction "}}}

function! s:parse_pattern(lines) "{{{
  if !len(a:lines) | return [[], ''] | endif
  let m = matchstr(a:lines[0], '^\[\zs.\+\ze\]$')
  return !empty(m) ? [a:lines[1 :], m] : [a:lines, '_']
endfunction "}}}

function! s:parse_properties(lines) "{{{
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
endfunction "}}}

function! s:eval(val) "{{{
  return type(a:val) == type('') && a:val =~# '^\d\+$' ? eval(a:val) : a:val
endfunction "}}}

function! s:properties() "{{{
  return map(s:globpath(s:scriptdir, '*.vim'), 'fnamemodify(v:val, ":t:r")')
endfunction "}}}

function! s:globpath(path, expr) "{{{
  return has('patch-7.4.279') ? globpath(a:path, a:expr, 0, 1) : split(globpath(a:path, a:expr, 1))
endfunction "}}}

function! s:trim(lines) "{{{
  return filter(map(a:lines, 's:remove_comment(v:val)'), '!empty(v:val)')
endfunction "}}}

function! s:remove_comment(line) "{{{
  let pos = match(a:line, '[;#].\+')
  return pos == -1 ? a:line : pos == 0 ? '' : a:line[: pos-1]
endfunction "}}}

function! s:set_cwd(dir) "{{{
  if g:editorconfig_root_chdir
    lcd `=a:dir`
  endif
endfunction "}}}

function! s:apply(property) "{{{
  for [key, val] in items(a:property)
    try
      call editorconfig#{key}#execute(val)
    catch /^Vim\%((\a\+)\)\=:E117/
      echohl WarningMsg | echomsg 'editorconfig: Unsupported property:' key | echohl NONE
    endtry
  endfor
endfunction "}}}

function! s:filter_matched(config, path) "{{{
  let _ = {}
  call map(filter(copy(a:config), 'a:path =~ s:regexp(v:val[0])'), 'extend(_, v:val[1], "keep")')
  return _
endfunction "}}}

function! s:regexp(pattern) "{{{
  let pattern = escape(a:pattern, '.\')
  for rule in s:regexp_rules
    let pattern = substitute(pattern, rule[0], rule[1], 'g')
  endfor
  return pattern . '$'
endfunction "}}}
let s:regexp_rules =
      \ [ ['\[!', '[^']
      \ , ['{\(\f\+\),\(\f\+\)}' ,'\\%(\1\\|\2\\)']
      \ , ['\*\{2}', '.\\{}']
      \ , ['\(\.\)\@<!\*', '[^\\/]\\{}']]
" 1}}}

let &cpo = s:save_cpo
unlet s:save_cpo
