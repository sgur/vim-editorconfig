scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:editorconfig = '.editorconfig'

let s:scriptdir = expand('<sfile>:p:r')

" {{{1 Interfaces

" >>> let g:editorconfig_blacklist = {'filetype': [], 'pattern': []}
" >>> call editorconfig#load()
"
function! editorconfig#load() abort
  augroup plugin-editorconfig-local
    autocmd! * <buffer>
  augroup END
  if !&modifiable
    " Ignore nomodifiable files
    return
  endif
  let filepath = expand('%:p')
  if s:blacklist(filepath, &filetype)
    return
  endif
  let rule = s:scan(fnamemodify(filepath, ':h'))
  let props = s:filter_matched(rule, filepath)
  if empty(props) | return | endif
  call s:fill_defaults(props)
  let b:editorconfig = props
  let unsupported = s:apply(props)
  if empty(unsupported)
    return
  endif
  for key in unsupported
    let b:editorconfig[key] = 'UNSUPPORTED'
  endfor
  if get(g:, 'editorconfig_verbose', 0)
    echohl WarningMsg | echomsg 'editorconfig: Unsupported property:' join(unsupported, ',') | echohl NONE
  endif
endfunction

function! editorconfig#omnifunc(findstart, base) abort
  if a:findstart
    let pos = match(getline('.'), '\%' . col('.') . 'c\k\+\zs\s*=')
    return pos+1
  else
    return filter(sort(s:properties()), 'stridx(v:val, a:base) == 0')
  endif
endfunction

" {{{1 Inner functions

" if `root = true` then dirname is located at s:scan(...)[0]
" >>> let s:root = s:scan(expand('%:p:h'))[0]
" >>> echo type(s:root) isdirectory(s:root[1].root)
" 3 1

" >>> let [s:pattern, s:config] = s:scan(expand('%:p:h'))[1]
" >>> echo s:pattern
" *.vim

" >>> echo s:config.insert_final_newline s:config.indent_style s:config.indent_size
" true space 2

function! s:scan(path) abort "{{{
  let editorconfig = findfile(s:editorconfig, fnameescape(a:path) . ';')
  if empty(editorconfig) || !filereadable(editorconfig) || a:path is# fnamemodify(a:path, ':h')
    return []
  endif
  let base_path = fnamemodify(editorconfig, ':p:h')
  let [is_root, _] = s:parse(s:trim(readfile(editorconfig)))
  if is_root
    return [['*', {'root': base_path}]] + _
  endif
  return s:scan(fnamemodify(base_path, ':h')) + _
endfunction "}}}

" Parse lines into rule lists
" >>> let [s:is_root, s:lists] = s:parse(['root = false', '[*]', 'indent_size = 2'])
" >>> echo s:is_root
" 0
" >>> echo s:lists[0][0]
" *
" >>> echo s:lists[0][1]
" {'indent_size': 2}
" >>> let g:editorconfig_verbose = 1
" >>> echo s:parse(['root = false', '[*', 'indent_size = 2'])
" Vim(echoerr):editorconfig: failed to parse [*
" >>> let g:editorconfig_verbose = 0
" >>> echo s:parse(['root = false', '[*', 'indent_size = 2'])
" [0, []]

function! s:parse(lines) abort "{{{
  let [unparsed, is_root] = s:parse_properties(a:lines)
  let _ = []
  while len(unparsed) > 0
    let [unparsed, pattern] = s:parse_pattern(unparsed)
    let [unparsed, properties] = s:parse_properties(unparsed)
    let _ += [[pattern, properties]]
  endwhile
  return [get(is_root, 'root', 'false') ==# 'true', _]
endfunction "}}}

" Parse file glob pattern
" >>> echo s:parse_pattern([])
" [[], '']
" >>> echo s:parse_pattern(['[*.vim]', 'abc'])
" [['abc'], '*.vim']
" >>> let g:editorconfig_verbose = 1
" >>> echo s:parse_pattern(['[]', ''])
" Vim(echoerr):editorconfig: failed to parse []
" >>> let g:editorconfig_verbose = 0
" >>> echo s:parse_pattern(['[]', ''])
" [[], '']

function! s:parse_pattern(lines) abort "{{{
  if !len(a:lines) | return [[], ''] | endif
  let m = matchstr(a:lines[0], '^\[\zs.\+\ze\]$')
  if !empty(m)
    return [a:lines[1 :], m]
  else
    if get(g:, 'editorconfig_verbose', 0)
      echoerr printf('editorconfig: failed to parse %s', a:lines[0])
    endif
    return [[], '']
  endif
endfunction "}}}

" Skip pattern fields
" >>> echo s:parse_properties(['[*.vim]', 'abc'])
" [['[*.vim]', 'abc'], {}]
"
" Parse property and store the fields as dictionary
" >>> echo s:parse_properties(['indent_size=2', '[*]'])
" [['[*]'], {'indent_size': 2}]

function! s:parse_properties(lines) abort "{{{
  let _ = {}
  if !len(a:lines) | return [[], _] | endif
  for i in range(len(a:lines))

    let line = a:lines[i]

    " Parse comments
    let m = matchstr(line, '^#')
    if !empty(m)
      return [[], {}]
    endif
    let m = matchstr(line, '^;')
    if !empty(m)
      return [[], {}]
    endif

    " Parse file formats
    let m = matchstr(line, '^\[\zs.\+\ze\]$')
    if !empty(m)
      return [a:lines[i :], _]
    endif

    " Parse properties
    let splitted = split(matchstr(line, '^\s*\zs\S.*\S\ze\s*$'), '\s*=\s*')
    if len(splitted) < 2
      if get(g:, 'editorconfig_verbose', 0)
        echoerr printf('editorconfig: failed to parse %s', line)
      endif
      return [[], {}]
    endif
    let [key, val] = splitted
    let _[key] = s:eval(val)

  endfor
  return [a:lines[i+1 :], _]
endfunction "}}}

let s:defaults = {'tab_width': 'indent_size'}

function! s:fill_defaults(props) abort "{{{
  for prop in keys(s:defaults)
    if (!has_key(a:props, prop) && has_key(a:props, s:defaults[prop]))
      let a:props[prop] = a:props[s:defaults[prop]]
    endif
  endfor
endfunction "}}}

" >>> echo s:eval('2')
" 2
" >>> echo s:eval('true')
" true

function! s:eval(val) abort "{{{
  return type(a:val) == type('') && a:val =~# '^\d\+$' ? eval(a:val) : a:val
endfunction "}}}

function! s:properties() abort "{{{
  return map(s:globpath(&runtimepath, 'autoload/editorconfig/*.vim'), 'fnamemodify(v:val, ":t:r")')
endfunction "}}}

function! s:globpath(path, expr) abort "{{{
  return has('patch-7.4.279') ? globpath(a:path, a:expr, 0, 1) : split(globpath(a:path, a:expr, 1))
endfunction "}}}

" >>> echo s:trim(['# ', 'foo', '', 'bar'])
" ['foo', 'bar']

function! s:trim(lines) abort "{{{
  return filter(map(a:lines, 's:remove_comment(v:val)'), '!empty(v:val)')
endfunction "}}}

" >>> echo s:remove_comment('# foo')
"
" >>> echo s:remove_comment('bar')
" bar
" >>> echo s:remove_comment('#')
"

function! s:remove_comment(line) abort "{{{
  let pos = match(a:line, '\s*[;#].*')
  return pos == -1 ? a:line : pos == 0 ? '' : a:line[: pos-1]
endfunction "}}}

function! s:apply(property) abort "{{{
  let unsupported_keys = []
  for [key, val] in items(a:property)
    try
      call editorconfig#{tolower(key)}#execute(val)
    catch /^Vim\%((\a\+)\)\=:E117/
      let unsupported_keys += [key]
    endtry
  endfor
  return unsupported_keys
endfunction "}}}

function! s:filter_matched(rule, path) abort "{{{
  let _ = {}
  call map(filter(copy(a:rule), 'a:path =~ s:regexp(v:val[0])'), 'extend(_, v:val[1], "force")')
  return _
endfunction "}}}

" >>> let g:editorconfig_blacklist = {'filetype': ['vim'], 'pattern': []}
" >>> echo s:blacklist('sample1.vim', 'vim')
" 1
"
" >>> let g:editorconfig_blacklist = {'filetype': [], 'pattern': []}
" >>> echo s:blacklist('sample1.vim', 'vim')
" 0
"
" >>> let g:editorconfig_blacklist = {'filetype': ['^$'], 'pattern': []}
" >>> echo s:blacklist('sample1.vim', 'vim')
" 0
"
" >>> let g:editorconfig_blacklist = {'filetype': ['vim'], 'pattern': []}
" >>> echo s:blacklist('sample1.vim', '')
" 0
function! s:blacklist(filepath, filetype) abort " {{{
  if has_key(g:editorconfig_blacklist, 'filetype')
    return !empty(filter(copy(g:editorconfig_blacklist.filetype),
          \ 'match(a:filetype, v:val) != -1'))
  endif
  if has_key(g:editorconfig_blacklist, 'pattern')
    return !empty(filter(copy(g:editorconfig_blacklist.pattern), 'match(a:filepath, v:val) != -1'))
  endif
  return 0
endfunction "}}}

function! s:regexp(pattern) abort "{{{
  let pattern = escape(a:pattern, '.\')
  for rule in s:regexp_rules
    let pattern = substitute(pattern, rule[0], rule[1], 'g')
  endfor
  return '\<'. pattern . '$'
endfunction "}}}
let s:regexp_rules =
      \ [ ['\[!', '[^']
      \ , ['{\zs[^}]*\ze}', '\=substitute(submatch(0), ",", "\\\\|", "g")']
      \ , ['{\([^}]\+\)}', '\\%(\1\\)']
      \ , ['\*\{2}', '.\\{}']
      \ , ['\(\.\)\@<!\*', '[^\\/]\\{}']]
" 1}}}

let &cpo = s:save_cpo
unlet s:save_cpo
