scriptencoding utf-8

" c_include_path {{{1

" >>> setlocal path<
" >>> call editorconfig#c_include_path#execute('foo:bar')
" >>> echo &l:path == &g:path . ',foo,bar'
" 1

" >>> setlocal path<
" >>> call editorconfig#c_include_path#execute('foo;bar;')
" >>> echo &l:path == &g:path . ',foo,bar'
" 1

" >>> setlocal path<
" >>> call editorconfig#c_include_path#execute(0)
" >>> echo &l:path == &g:path
" 1

" @value: Directory paths separated by colon (:) or semi-colon (;)
function! editorconfig#c_include_path#execute(value) abort
  if type(a:value) == type("")
    let raw_path = has('win32') ? tr(a:value, '\', '/') : a:value
    let paths = split(escape(a:value, ' '), '[;:]\([\/]\)\@!')
    let &l:path .= ',' . join(paths, ',')
  elseif get(g:, 'editorconfig_verbose', 0)
    echoerr printf('editorconfig: unsupported value: c_include_path=%s', a:value)
  endif
endfunction

" 1}}}
