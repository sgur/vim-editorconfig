scriptencoding utf-8

" indent_size {{{1

" >>> call editorconfig#indent_size#execute(3)
" >>> echo &shiftwidth
" 3
"
" >>> call editorconfig#indent_size#execute('tab')
" >>> echo &shiftwidth
" 0

function! editorconfig#indent_size#execute(value) abort
  " [:digit:]+ or 'tab'
  if type(a:value) == type(0)
    let &l:shiftwidth = a:value
  elseif a:value is# 'tab'
    setlocal shiftwidth=0
  elseif get(g:, 'editorconfig_verbose', 0)
    echoerr printf('editorconfig: unsupported value: indent_size=%s', a:value)
  endif
endfunction
" 1}}}
