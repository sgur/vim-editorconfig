scriptencoding utf-8

function! editorconfig#charset#execute(value)
  " encoding
  execute 'setlocal fileencoding=' . a:value
  execute 'setlocal fileencodings^=' . a:value
endfunction

