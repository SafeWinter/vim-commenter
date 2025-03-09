vim9script

const comment_string = '# '
# Comment out the current line in Python
export def Comment()
  var i = indent('.') # Number of spaces
  var line = getline('.')
  var cur_row = getcurpos()[1]
  var cur_col = getcurpos()[2]
  setline('.', line[ : i - 1] .. comment_string .. line[i : ])
  cursor(cur_row, cur_col + len(comment_string))
enddef
nnoremap gc = <ScriptCmd>Comment()<cr>

