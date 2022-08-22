" function! s:cargo_root(path) abort
"     let l:path = a:path
"     let l:ParentDir = {path -> fnamemodify(path, ':p:h')}
"     let l:manifest = ''
"     while l:manifest ==# ''
"         let l:manifest = findfile('Cargo.toml', l:path)
"         let l:path = l:ParentDir(l:path)
"     endwhile
"     return l:ParentDir(l:path)
" endfunction

" compiler cargo
" let s:root = s:cargo_root(getcwd())
" let s:name = fnamemodify(s:root, ':t')
" let b:start = s:root . '/target/debug/' . s:name
