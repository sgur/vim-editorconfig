scriptencoding utf-8

function! editorconfig#trim_trailing_whitespace#execute(value) "{{{
  " 'true' or 'false'
  if a:value == 'true'
    autocmd plugin-editorconfig-local BufWritePre <buffer> call s:do_trim_trailing_whitespace()
  elseif a:value== 'false'
  else
    echoerr printf('editroconfig: unsupported value: trim_trailing_whitespace=%s', a:value)
  endif
endfunction "}}}

function! s:do_trim_trailing_whitespace() "{{{
  let view = winsaveview()
  try
    %s/\s\+$//e
  finally
    call winrestview(view)
  endtry
endfunction "}}}
