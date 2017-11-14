scriptencoding utf-8

" spell_language {{{1

" >>> call editorconfig#spell_language#execute(8)
" >>> echo &tabstop
" 8

function! editorconfig#spell_language#execute(value) abort
  " [:digit:]+
  if type(a:value) == type("")
    execute 'setlocal spelllang=' . a:value
  elseif get(g:, 'editorconfig_verbose', 0)
    echoerr printf('editorconfig: unsupported value: spell_language=%s', a:value)
  endif
endfunction
" 1}}}
