scriptencoding utf-8

" charset {{{1

" >>> call editorconfig#charset#execute('cp932')
" >>> echo &l:fileencoding
" cp932

function! editorconfig#charset#execute(value)
  " encoding
  execute 'setlocal fileencoding=' . a:value
endfunction
" 1}}}
