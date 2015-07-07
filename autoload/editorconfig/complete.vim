scriptencoding utf-8

function! editorconfig#complete#omnifunc(findstart, base)
  if a:findstart
    let pos = match(getline('.'), '\%' . col('.') . 'c\k\+\zs\s*=')
    return pos+1
  else
    return filter(sort(editorconfig#properties()), 'stridx(v:val, a:base) == 0')
  endif
endfunction

