scriptencoding utf-8

" tab_width {{{1

" >>> call editorconfig#tab_width#execute(8)
" >>> echo &tabstop
" 8

function! editorconfig#tab_width#execute(value)
  " [:digit:]+
  if type(a:value) == type(0)
    execute 'setlocal tabstop=' . a:value
  elseif get(g:, 'editorconfig_verbose', 0)
    echoerr printf('editorconfig: unsupported value: tab_width=%s', a:value)
  endif
endfunction
" 1}}}
