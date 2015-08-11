" editorconfig
" Version: 0.4.0
" Author: sgur
" License: MIT License

if exists('g:loaded_editorconfig')
  finish
endif
let g:loaded_editorconfig = 1

let s:save_cpo = &cpo
set cpo&vim

let g:editorconfig_root_chdir = get(g:, 'editorconfig_root_chdir', 0)

augroup plugin-editorconfig
  autocmd!
  autocmd VimEnter * nested
        \ if !argc() | call editorconfig#load() | endif
  autocmd BufNewFile,BufReadPost * nested
        \ call editorconfig#load()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
