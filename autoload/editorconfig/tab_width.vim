scriptencoding utf-8

function! editorconfig#tab_width#execute(value) "{{{
  " [:digit:]+
  if type(a:value) == type(0)
    execute 'setlocal tabstop=' . a:value
  else
    echoerr printf('editorconfig: unsupported value: tab_width=%s', a:value)
  endif
endfunction "}}}

