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
  elseif type(a:value) == type("") && s:match_encoding_pattern(a:value)
    let &fileencoding = a:value
  elseif get(g:, 'editorconfig_verbose', 0)
    echoerr printf('editorconfig: unsupported value: charset=%s', a:value)
  endif
endfunction

function! s:match_encoding_pattern(enc_name) abort "{{{
  if index(s:encoding, a:enc_name) > -1
    return 1
  endif

  for pattern in s:encoding_patterns
    if a:enc_name =~ pattern
      return 2
    endif
  endfor

  return 0
endfunction "}}}

let s:encoding = [
      \ 'latin1',
      \ 'iso-8859-n',
      \ 'koi8-r',
      \ 'koi8-u',
      \ 'macroman',
      \ 'cp437',
      \ 'cp737',
      \ 'cp775',
      \ 'cp850',
      \ 'cp852',
      \ 'cp855',
      \ 'cp857',
      \ 'cp860',
      \ 'cp861',
      \ 'cp862',
      \ 'cp863',
      \ 'cp865',
      \ 'cp866',
      \ 'cp869',
      \ 'cp874',
      \ 'cp1250',
      \ 'cp1251',
      \ 'cp1253',
      \ 'cp1254',
      \ 'cp1255',
      \ 'cp1256',
      \ 'cp1257',
      \ 'cp1258',
      \ 'cp932',
      \ 'euc-jp',
      \ 'sjis',
      \ 'cp949',
      \ 'euc-kr',
      \ 'cp936',
      \ 'euc-cn',
      \ 'cp950',
      \ 'big5',
      \ 'euc-tw',
      \ 'utf-8',
      \ 'ucs-2',
      \ 'ucs-2le',
      \ 'utf-16',
      \ 'utf-16le',
      \ 'ucs-4',
      \ 'ucs-4le',
      \ ]
let s:encoding_patterns = [
      \ '^8bit-\S\+$',
      \ '^2byte-\S\+$',
      \ '^cp\d\+$',
      \ ]

" 1}}}
