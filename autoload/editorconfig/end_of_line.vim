scriptencoding utf-8

function! editorconfig#end_of_line#execute(value) "{{{
  " 'lf', 'cr' or 'crlf'
  try
    execute s:end_of_line[tolower(a:value)]
  catch /^Vim\%((\a\+)\)\=:E716/
    echoerr printf('editorconfig: unsupported value: end_of_line=%s', a:value)
  endtry
endfunction "}}}

let s:end_of_line =
      \ { 'lf': 'setlocal fileformat=unix'
      \ , 'cr': 'setlocal fileformat=mac'
      \ , 'crlf': 'setlocal fileformat=dos'
      \ }
