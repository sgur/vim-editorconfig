scriptencoding utf-8

" trim_trailing_whitespace {{{1

" >>> silent! new ./test.text
" >>> call editorconfig#trim_trailing_whitespace#execute('true')
" >>> execute "normal! :silent 0insert\<CR>abcde\<Space>\<CR>"
" >>> execute "normal! :silent w\<CR>"
" "test.text" [New] 1L, 7C written
" >>> echo getline(1)
" abcde
" >>> bwipeout test.text
" >>> execute "normal! :call delete('./test.text')\<CR>"

function! editorconfig#trim_trailing_whitespace#execute(value)
  " 'true' or 'false'
  if a:value == 'true'
    autocmd plugin-editorconfig-local BufWritePre <buffer> call s:do_trim_trailing_whitespace()
  elseif a:value == 'false'
  else
    echoerr printf('editroconfig: unsupported value: trim_trailing_whitespace=%s', a:value)
  endif
endfunction

function! s:do_trim_trailing_whitespace() "{{{
  let view = winsaveview()
  try
    %s/\s\+$//e
  finally
    call winrestview(view)
  endtry
endfunction "}}}
" 1}}}
