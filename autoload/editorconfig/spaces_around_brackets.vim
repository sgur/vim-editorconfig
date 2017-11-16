scriptencoding utf-8

" spaces_around_brackets {{{1
" https://github.com/editorconfig/editorconfig/wiki/EditorConfig-Properties

" Interface {{{2

function! editorconfig#spaces_around_brackets#execute(value) abort
  if a:value is# 'none' " no space
  elseif a:value is# 'inside' " only inside the brachets
    autocmd plugin-editorconfig-local BufWritePre <buffer>
          \ call s:filter(bufnr('%'), function('s:fn_space_after_paren'), function('s:fn_space_before_paren'))
  elseif a:value is# 'outside' " only outside the brackets
    autocmd plugin-editorconfig-local BufWritePre <buffer>
          \ call s:filter(bufnr('%'), function('s:fn_space_before_paren'), function('s:fn_space_after_paren'))
  elseif a:value is# 'both' " at the both side of brackets
    autocmd plugin-editorconfig-local BufWritePre <buffer>
          \ call s:filter(bufnr('%'), function('s:fn_space_both_paren'), function('s:fn_space_both_paren'))
  else
    echoerr printf('editorconfig: unsupported value: spaces_around_brackets=%s', a:value)
  endif
endfunction

" Internal {{{2

function! s:filter_no_space_around_brackets(bufnr) abort "{{{
  execute a:bufnr . 'buffer'
  for lnum in range(1, line('$'))
    let str = getline(lnum)
    let line = substitute(str, '\s*\([()]\)\s*', '\=submatch(1)', 'g')
    call setline(lnum, line)
  endfor
endfunction "}}}
" call s:filter_no_space_around_brackets(bufnr('%'))

function! s:fn_pass_through(pos, paren) abort "{{{
  return [a:pos[0]]
endfunction "}}}

function! s:fn_space_after_paren(pos, paren) abort "{{{
  return [a:paren] + [' ']
endfunction "}}}

function! s:fn_space_before_paren(pos, paren) abort "{{{
  return [' '] + [a:paren]
endfunction "}}}

function! s:fn_space_both_paren(pos, paren) abort "{{{
  return [' '] + [a:paren] + [' ']
endfunction "}}}

function! s:filter(bufnr, fn_open, fn_close) abort "{{{
  execute a:bufnr . 'buffer'
  for lnum in range(1, line('$'))
    let str = getline(lnum)
    let ln = []
    let cnum = 0
    " echo lnum . ':' . str
    " echo ''
    while cnum < strlen(str)
      let pos = matchstrpos(str, '^\s*[([]\s*', cnum)
      if pos != ['', -1, -1] && !s:is_ignored_syntax(lnum, match(str, '[([]', cnum))
        " echon 'open[' cnum . '->' . pos[1] . ']'
        let paren = matchstr(str, '[([]', cnum)
        let ln += [str[cnum : pos[1]-1]]
        let ln += a:fn_open(pos, paren)
        let cnum = pos[2]
        continue
      endif

      let pos = matchstrpos(str, '^\s*[)\]]\s*', cnum)
      if pos != ['', -1, -1] && !s:is_ignored_syntax(lnum, match(str, '[)\]]', cnum))
        " echon 'close[' . cnum . '->' . pos[1]. ']'
        let parenpos = matchstrpos(str, '[)\]]', cnum)
        let paren = parenpos[0]
        let ln += [str[cnum : pos[1]-1]]
        let ln += a:fn_close(pos, paren)
        if parenpos[1]+1 == strlen(str)
          call remove(ln, -1)
        endif
        let cnum = pos[2]
        continue
      endif

      let ln += [str[cnum]]
      let cnum += 1
    endwhile
    call setline(lnum, join(ln, ''))
  endfor
endfunction "}}}

function! s:is_ignored_syntax(lnum, col) abort "{{{
  return !empty(
        \   filter(
        \     map(synstack(a:lnum, a:col+1),
        \       'synIDattr(synIDtrans(v:val),''name'')'),
        \     'index([''String'', ''Character'', ''Quote'', ''Escape'', ''Comment''], v:val) != -1'))
endfunction "}}}

