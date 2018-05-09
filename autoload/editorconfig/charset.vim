scriptencoding utf-8

" charset {{{1

" >>> call editorconfig#charset#execute('utf-8')
" >>> echo &l:fileencoding
" utf-8

" https://github.com/sgur/vim-editorconfig/issues/30#issuecomment-387266760
" >>> call editorconfig#charset#execute('cp932 | !echo "you''ve been hacked 1"')
" >>> echo &l:fileencoding
" utf-8

function! editorconfig#charset#execute(value) abort
  " encoding
  if type(a:value) == type("") && a:value !~ '|'
    let &l:fileencoding = a:value
  elseif a:value is? 'utf-8-bom'
    setlocal fileencoding=utf-8
    setlocal bomb
  elseif get(g:, 'editorconfig_verbose', 0)
    echoerr printf('editorconfig: unsupported value: charset=%s', a:value)
  endif
endfunction
" 1}}}
