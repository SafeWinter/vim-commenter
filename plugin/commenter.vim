" Comment out the current line in Python
function! commenter#Comment()
    let l:line = getline('.')
    call setline('.', '# ' . l:line)
endfunction
nnoremap gc :call commenter#Comment()<cr>

