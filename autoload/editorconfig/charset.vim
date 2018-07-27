scriptencoding utf-8

" charset {{{1

" >>> let s:fenc_bak = &l:fileencoding

" >>> call editorconfig#charset#execute('utf-8')
" >>> echo &l:fileencoding
" utf-8

" >>> call editorconfig#charset#execute('cp932')
" >>> echo &l:fileencoding
" cp932

" >>> call editorconfig#charset#execute('8bit-cp1252')
" >>> echo &l:fileencoding
" 8bit-cp1252

" >>> call editorconfig#charset#execute('2byte-cp932')
" >>> echo &l:fileencoding
" cp932

" https://github.com/sgur/vim-editorconfig/issues/30#issuecomment-387266760
" >>> setlocal fileencoding=utf-8
" >>> call editorconfig#charset#execute('cp932 | !echo "you''ve been hacked 1"')
" >>> echo &l:fileencoding
" utf-8

" https://github.com/sgur/vim-editorconfig/issues/30#issuecomment-407931236
" >>> setlocal fileencoding=latin1
" >>> call editorconfig#charset#execute('cp932 foldexpr:execute(\"let\ g:editorconfig_local_vimrc\\75\ 1\") foldmethod:expr foldenable foldlevel:0')
" >>> echo &l:fileencoding
" latin1

" >>> let &l:fileencoding = s:fenc_bak

function! editorconfig#charset#execute(value) abort
  " encoding
  if a:value is? 'utf-8-bom'
    setlocal fileencoding=utf-8
    setlocal bomb
  elseif type(a:value) == type("") && a:value !~ '|'
    let &fileencoding = a:value
  elseif get(g:, 'editorconfig_verbose', 0)
    echoerr printf('editorconfig: unsupported value: charset=%s', a:value)
  endif
endfunction
" 1}}}
