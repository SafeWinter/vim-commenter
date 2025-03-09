vim9script

const comment_string = '# '
# Comment out the current line in Python
export def ToggleComment()
  var i = indent('.') # Number of spaces
  var line = getline('.')
  var cur_row = getcurpos()[1]
  var cur_col = getcurpos()[2]
  var cur_offset = 0
  if line[i : i + len(comment_string) - 1] ==# comment_string
    setline('.', line[ : i - 1] .. line[i + len(comment_string) : ])
  else
    setline('.', line[ : i - 1] .. comment_string .. line[i : ])
    cur_offset = len(comment_string)
  endif
  cursor(cur_row, cur_col + cur_offset)
enddef
nnoremap gc = <ScriptCmd>ToggleComment()<cr>

