scriptencoding utf-8

" indent_style {{{1

" >>> call editorconfig#indent_style#execute('tab')
" >>> echo &expandtab
" 0
"
" >>> call editorconfig#indent_style#execute('space')
" >>> echo &expandtab
" 1

function! editorconfig#indent_style#execute(value)
  try
    execute s:indent_style[a:value]
  catch /^Vim\%((\a\+)\)\=:E716/
    echoerr printf('editorconfig: unsupported value: indent_style=%s', a:value)
  endtry
endfunction

let s:indent_style =
      \ { 'tab': 'setlocal noexpandtab'
      \ , 'space': 'setlocal expandtab'
      \ }
" 1}}}
