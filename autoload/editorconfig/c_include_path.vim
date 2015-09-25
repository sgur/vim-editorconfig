scriptencoding utf-8

" c_include_path {{{1

" @value: Directory paths separated by colon (:) or semi-colon (;)
function! editorconfig#c_include_path#execute(value) abort
  let raw_path = has('win32') ? tr(a:value, '\', '/') : a:value
  let paths = split(escape(a:value, ' '), '[;:]\([\/]\)\@!')
  let &l:path .= ',' . join(paths, ',')
endfunction

" 1}}}
