scriptencoding utf-8

" spell_language {{{1

" >>> let s:spelllang_bak = &l:spelllang

" >>> call editorconfig#spell_language#execute('en_us')
" >>> echo &spelllang
" en_us

" https://github.com/sgur/vim-editorconfig/issues/30#issuecomment-387266760
" >>> call editorconfig#spell_language#execute('ja_JP | !echo "you''ve been hacked 2"')
" >>> echo &spelllang
" en_us

" >>> let &l:spelllang = s:spelllang_bak

function! editorconfig#spell_language#execute(value) abort
  " [:digit:]+
  echom a:value
  if type(a:value) == type("") && s:lang_available(a:value)
    let &spelllang = a:value
  elseif get(g:, 'editorconfig_verbose', 0)
    echoerr printf('editorconfig: unsupported value: spell_language=%s', a:value)
  endif
endfunction

function! s:lang_available(value) abort "{{{
  return !empty(filter(copy(s:languages), 'stridx(v:val, a:value) == 0'))
endfunction "}}}

let s:languages = map(filter(globpath(&runtimepath, 'spell/*', 1, 1), '!isdirectory(v:val)'), 'fnamemodify(v:val, '':t'')')

" 1}}}
