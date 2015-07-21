scriptencoding utf-8

function! editorconfig#indent_size#execute(value) "{{{
  " [:digit:]+ or 'tab'
  if type(a:value) == type(0)
    execute 'setlocal shiftwidth=' . a:value
  elseif a:value is# 'tab'
    execute 'setlocal shiftwidth=0'
  else
    echoerr printf('editorconfig: unsupported value: indent_size=%s', a:value)
  endif
endfunction "}}}

