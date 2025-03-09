vim9script

# Comment out the current line in Python
export def Comment()
  var line = getline('.')
  setline('.', '# ' .. line)
enddef
nnoremap gc = <ScriptCmd>Comment()<cr>

