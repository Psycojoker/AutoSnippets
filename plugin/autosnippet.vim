function! AutoSnippet()
python << EOF
import vim
import re

def current_line():
    (row, col) = vim.current.window.cursor
    return vim.current.buffer[row-1]

(row, col) = vim.current.window.cursor
line = current_line()

if col == len(line) - 1:
    if re.match("^ *from [\w.]+ $", line):
        vim.current.buffer[row-1] = line + "import "
        vim.command("norm! A")
    elif re.match("^ *for [a-zA-Z]+ $", line):
        vim.current.buffer[row-1] = line + "in "
        vim.command("norm! A")
    elif re.match("^ *for [a-zA-Z, ]+?[^,] $", line):
        vim.current.buffer[row-1] = line + "in "
        vim.command("norm! A")
    elif re.match("^ *((while|class|def|for|except) .+|else|try|(el)?if .+):$", line):
        spaces = re.match("(^ *)", line).groups()[0]
        # stupid dirty trick to make a <cr> while conserving indentation
        vim.command("norm! ox")
        vim.command("norm! $x")
EOF
endfunction

augroup filetype_python
    autocmd!
    autocmd FileType python inoremap <space> <space>:call AutoSnippet()<cr>
    autocmd FileType python inoremap : ::call AutoSnippet()<cr>
augroup END
