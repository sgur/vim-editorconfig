" editorconfig
" Version: 0.1.0
" Author: sgur
" License: MIT License

if exists('g:loaded_editorconfig')
  finish
endif
let g:loaded_editorconfig = 1

let s:save_cpo = &cpo
set cpo&vim

let g:editorconfig_filename = get(g:, 'editorconfig_filename', '.editorconfig')

augroup plugin-editorconfig
  autocmd!
  autocmd VimEnter * nested
        \   if argc() == 0
        \ |   call editorconfig#load(expand('<amatch>'))
        \ | endif
  autocmd BufNewFile,BufReadPost * nested
        \ call editorconfig#load(expand('<amatch>'))
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
