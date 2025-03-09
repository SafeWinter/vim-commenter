vim9script

# 定义 Python 专用的注释符号（buffer-local 常量）
const b:commenter_comment_string = '# '
lockvar b:commenter_comment_string  # 强制锁定为常量
