vim9script

# Comment out the current line in Python
export def ToggleComment()
  if !exists('b:commenter_comment_string')
    echoerr 'Comment string not defined for filetype: ' .. &filetype
    return
  endif

  const comment_string = b:commenter_comment_string
  const i = indent('.')                     # Number of indent spaces
  const line = getline('.')                 # Content of current line
  const cur_row = getcurpos()[1]            # Current row number
  const cur_col = getcurpos()[2]            # Current column number
  const prefix = i > 0 ? line[: i - 1] : '' # Handle 0 indent
  const comment_len = len(comment_string)
  const has_commented = line[i : i + len(comment_string) - 1] ==# comment_string
  if has_commented
    # Cancel comment
    setline('.', prefix .. line[i + comment_len : ])
  else
    # Make comment line
    setline('.', prefix .. comment_string .. line[i : ])
  endif
  const cur_offset = has_commented ? 0 : comment_len
  cursor(cur_row, cur_col + cur_offset)
enddef

nnoremap gc = <ScriptCmd>ToggleComment()<cr>

