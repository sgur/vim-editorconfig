scriptencoding utf-8

function! editorconfig#spell_enabled#execute(value) abort
  " 'true' or 'false'
  if a:value is# 'true'
    setlocal spell
  elseif a:value is# 'false'
    setlocal nospell
  elseif get(g:, 'editorconfig_verbose', 0)
    echoerr printf('editorconfig: unsupported value: spell_enabled=%s', a:value)
  endif
endfunction
