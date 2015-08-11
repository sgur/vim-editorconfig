scriptencoding utf-8

" max_line_length {{{1

" >>> call editorconfig#max_line_length#execute(78)
" >>> echo &textwidth
" 78

function! editorconfig#max_line_length#execute(value)
  " number
  if type(a:value) == type(0)
    execute 'setlocal textwidth=' . a:value
  elseif get(g:, 'editorconfig_verbose', 0)
    echoerr printf('editroconfig: unsupported value: max_line_length=%s', a:value)
  endif
endfunction
" 1}}}
