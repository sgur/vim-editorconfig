scriptencoding utf-8

" tab_width {{{1

" >>> setlocal tabstop=4
" >>> call editorconfig#tab_width#execute(8)
" >>> echo &l:tabstop
" 8

" >>> setlocal tabstop=4
" >>> call editorconfig#tab_width#execute('3')
" >>> echo &l:tabstop
" 4

function! editorconfig#tab_width#execute(value) abort
  " [:digit:]+
  if type(a:value) == type(0)
    let &l:tabstop = a:value
  elseif get(g:, 'editorconfig_verbose', 0)
    echoerr printf('editorconfig: unsupported value: tab_width=%s', a:value)
  endif
endfunction
" 1}}}
