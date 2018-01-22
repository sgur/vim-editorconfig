scriptencoding utf-8

" insert_final_newline {{{1

" After Vim 7.4.785:
"  Use &fixendofline
" Before 7.4.784:
"  Use BufWritePre and BufWritePost event to manipulate &binary and &endofline

function! editorconfig#insert_final_newline#execute(value) abort
  " 'true' or 'false'
  let value = s:bool(a:value)
  if exists('&fixendofline')
    let &l:fixendofline = value
  elseif !value
    autocmd plugin-editorconfig-local BufWritePre <buffer> call s:on_bufwritepre_insert_final_newline()
    autocmd plugin-editorconfig-local BufWritePost <buffer> call s:on_bufwritepost_insert_final_newline()
  endif
endfunction

function! s:bool(value) abort "{{{
  if a:value is# 'true'
    return 1
  elseif a:value is# 'false'
    return 0
  elseif get(g:, 'editorconfig_verbose', 0)
    echoerr printf('editorconfig: unsupported value: insert_final_newline=%s', a:value)
  endif
endfunction "}}}

" http://vim.wikia.com/wiki/Preserve_missing_end-of-line_at_end_of_text_files
function! s:on_bufwritepre_insert_final_newline() abort "{{{
  let s:save_binary = &binary
  if !&endofline && !&binary
    let s:save_view = winsaveview()
    setlocal binary
    if (&fileformat ==# 'dos' || &fileformat ==# 'mac') && line('$') > 1
      undojoin | execute "silent 1,$-1normal! A\<C-v>\<C-m>"
    endif
    if &fileformat ==# 'mac'
      undojoin | %join!
    endif
  endif
endfunction "}}}

function! s:on_bufwritepost_insert_final_newline() abort "{{{
  if !&endofline && ! s:save_binary
    if &fileformat ==# 'dos' && line('$') > 1
      silent! undojoin | silent 1,$-1s/\r$//e
    elseif &fileformat ==# 'mac'
      silent! undojoin | silent %s/\r/\r/ge
    endif
    setlocal nobinary
    call winrestview(s:save_view)
  endif
endfunction "}}}
" 1}}}

