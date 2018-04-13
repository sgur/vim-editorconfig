scriptencoding utf-8

" basedir {{{1


function! editorconfig#root#execute(value) abort
  if g:editorconfig_root_chdir && isdirectory(a:value) && getcwd() != a:value
    execute 'lcd' a:value
  endif
endfunction

