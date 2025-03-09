vim9script

# Returns true if b:commenter_comment_string exists.
def HasCommentStr(): bool
  if exists('b:commenter_comment_string')
    return true
  endif
  echoerr 'Comment string not defined for filetype: ' .. &filetype
  return false
enddef

# Detect smallest indentation for a range of lines.
def DetectMinIndent(start: number, end: number): number
  var min_indent = -1
  var i = start
  while i <= end
    if min_indent == -1 || indent(i) < min_indent
      min_indent = indent(i)
    endif
    i += 1
  endwhile
  return min_indent
enddef

def InsertOrRemoveComment(lnum: number, line: string, indent: number, has_commented: bool)
  # Handle 0 indent cases
  const prefix = indent > 0 ? line[ : indent - 1] : ''
  const comment_str = b:commenter_comment_string
  if has_commented
    # Remove comment sign
    setline(lnum, prefix .. line[indent + len(comment_str) : ])
  else 
    # Add comment sign
    setline(lnum, prefix .. comment_str .. line[indent : ])
  endif
enddef

# Comment out the current line in Python
export def ToggleComment(count: number)
  if !HasCommentStr()
    return
  endif

  const start = line('.')
  # Stop at the end of file.
  var end = start + count - 1
  if end > line('$') 
    end = line('$')
  endif

  const indent = DetectMinIndent(start, end)
  const lines = start == end ? [getline(start)] : getline(start, end)

  const cur_row = getcurpos()[1]            # Current row number
  const cur_col = getcurpos()[2]            # Current column number

  const comment_string = b:commenter_comment_string
  const comment_len = len(comment_string)
  const has_commented = lines[0][indent : indent + comment_len - 1] ==# comment_string

  var lnum = start
  for line in lines
    InsertOrRemoveComment(lnum, line, indent, has_commented)
    lnum += 1
  endfor
  const cur_offset = has_commented ? -comment_len : comment_len
  cursor(cur_row, cur_col + cur_offset)
enddef

