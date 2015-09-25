scriptencoding utf-8

" charset {{{1

" >>> call editorconfig#charset#execute('cp932')
" >>> echo &l:fileencoding
" cp932

function! editorconfig#charset#execute(value) abort
  " encoding
  if a:value is? 'utf-8-bom'
    setlocal fileencoding=utf-8
    setlocal bomb
  else
    execute 'setlocal fileencoding=' . a:value
  endif
endfunction
" 1}}}
