scriptencoding utf-8

function! editorconfig#max_line_length#execute(value) "{{{
  " number
  if type(a:value) == type(0)
    execute 'setlocal fileencoding=' . a:value
  else
    echoerr printf('editroconfig: unsupported value: max_line_length=%s', a:value)
  endif
endfunction "}}}

