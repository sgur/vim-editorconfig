scriptencoding utf-8

function! editorconfig#spell_enabled#execute(value) abort
  " 'true' or 'false'
  if a:value is# 'true'
    execute 'setlocal spell'
  elseif a:value is# 'false'
    execute 'setlocal nospell'
  elseif get(g:, 'editorconfig_verbose', 0)
    echoerr printf('editroconfig: unsupported value: spell_enabled=%s', a:value)
  endif
endfunction
