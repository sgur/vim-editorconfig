scriptencoding utf-8

" spell_language {{{1

" >>> call editorconfig#spell_language#execute('en_us')
" >>> echo &spelllang
" en_us

" https://github.com/sgur/vim-editorconfig/issues/30#issuecomment-387266760
" >>> call editorconfig#spell_language#execute('ja_JP | !echo "you''ve been hacked 2"')
" >>> echo &spelllang
" en_us

function! editorconfig#spell_language#execute(value) abort
  " [:digit:]+
  if type(a:value) == type("") && a:value !~ '|'
    let &l:spelllang = a:value
  elseif get(g:, 'editorconfig_verbose', 0)
    echoerr printf('editorconfig: unsupported value: spell_language=%s', a:value)
  endif
endfunction
" 1}}}
