vim9script

# Check if the comment string is defined for the current buffer.
def HasCommentStr(): bool
  const passed = exists('b:commenter_comment_string')
  if !passed
    echoerr 'Comment string not defined for filetype: ' .. &filetype
  endif
  return passed
enddef

# Detect the minimum indentation level within a range of lines.
def DetectMinIndent(start: number, end: number): number
  var min_indent = -1
  for lnum in range(start, end)
    const current_indent = indent(lnum)
    if min_indent == -1 || current_indent < min_indent
      min_indent = current_indent
    endif
  endfor
  return min_indent
enddef

# Insert or remove the comment string for a specific line.
def InsertOrRemoveComment(lnum: number, line: string, indent: number, has_commented: bool)
  const prefix = indent > 0 ? line[: indent - 1] : ''
  const comment_str = b:commenter_comment_string
  if has_commented
    # Remove the comment string
    setline(lnum, prefix .. line[indent + len(comment_str) : ])
  else
    # Add the comment string
    setline(lnum, prefix .. comment_str .. line[indent : ])
  endif
enddef

# Toggle comments for a range of lines.
export def ToggleComment(count: number)
  if !HasCommentStr()
    return
  endif

  const start = line('.')
  const end = min([start + count - 1, line('$')])  # Ensure we don't exceed the file length
  const min_indent = DetectMinIndent(start, end)
  const lines = getline(start, end)

  const cur_pos = getcurpos()
  const cur_row = cur_pos[1]  # Current row number
  const cur_col = cur_pos[2]  # Current column number

  const comment_str = b:commenter_comment_string
  const comment_len = len(comment_str)
  const has_commented = lines[0][min_indent : min_indent + comment_len - 1] ==# comment_str

  # Apply comment toggle to each line in the range
  for idx in range(len(lines))
    InsertOrRemoveComment(start + idx, lines[idx], min_indent, has_commented)
  endfor

  # Adjust cursor position
  const cur_offset = has_commented ? -comment_len : comment_len
  cursor(cur_row, cur_col + cur_offset)
enddef
