scriptencoding utf-8

" max_line_length {{{1

" >>> call editorconfig#max_line_length#execute(78)
" >>> echo &textwidth
" 78

function! editorconfig#max_line_length#execute(value) abort
  " number
  if type(a:value) == type(0)
    let &l:textwidth = a:value
  elseif a:value == 'off'
    " https://github.com/editorconfig/editorconfig/wiki/EditorConfig-Properties
    " says it should 'use the editor settings', which I guess means in
    " our case to do nothing.
    " So, this elseif is here only to accept value 'off' and not
    " complain about it.
  elseif get(g:, 'editorconfig_verbose', 0)
    echoerr printf('editorconfig: unsupported value: max_line_length=%s', a:value)
  endif
endfunction
" 1}}}
