vim9script

const comment_string = '# '
# Comment out the current line in Python
export def ToggleComment()
  const i = indent('.') # Number of spaces
  const line = getline('.')
  const cur_row = getcurpos()[1]
  const cur_col = getcurpos()[2]
  const prefix = i > 0 ? line[: i - 1] : '' # Handle 0 indent
  const has_commented = line[i : i + len(comment_string) - 1] ==# comment_string
  if has_commented
    setline('.', prefix .. line[i + len(comment_string) : ])
  else
    setline('.', prefix .. comment_string .. line[i : ])
  endif
  const cur_offset = has_commented ? 0 : len(comment_string)
  cursor(cur_row, cur_col + cur_offset)
enddef
nnoremap gc = <ScriptCmd>ToggleComment()<cr>

