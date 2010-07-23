" Copyright (c) 2010
" YinLubin <yinlubin@gmail.com>
" Version : 0.1
"
" We grant permission to use, copy modify, distribute, and sell this
" software for any purpose without fee, provided that the above copyright
" notice and this text are not removed. We make no guarantee about the
" suitability of this software for any purpose and we are not liable
" for any damages resulting from its use. Further, we are under no
" obligation to maintain or extend this software. It is provided on an
" "as is" basis without any expressed or implied warranty.
"
" Usage:
"   This file should reside in the plugin directory and be
" automatically sourced.
"
"   This plugin adds a command ":Pythondo", which is rather like ":perldo" or
" ":rubydo".
"
" You may use the command:
"
"   :[range]Pythondo {cmd}
"   :[range]Pyd {cmd}
"           Execute Python command {cmd} for each line in the
"            [range], with variable "s" being set to the text of each line in
"            turn, and variable "n" being the corresponding line number.  
"            Setting variable "s" will change the text, but note that it 
"            is not possible to add or delete lines using this command.
"            The default for [range] is the whole file: "1,$".
"            Setting variable "n" will set the text to line of number n, not
"            the current line. It's better not to set variable "n".
"   
"
" Here are some things you can try: >
"   :Pythondo s = str(n+1) + ' ' + s  # Add line number to each line
"   :py import time
"   :.Pythondo s = time.ctime()
"

let g:pythondo_version = "0.1"

if !has("python")
    echo "Sorry , Pythondo need python support for vim."
    finish
endif

if exists("s:enhanced_py_if")
    finish
endif
let s:enhanced_py_if = 1

python << END_OF_PYTHONDO
import vim
def pythondo(line1, line2, stopWhenError = True):
    cmd = vim.eval("b:pythondo_cmd")
    for line in range(line1 - 1, line2):
        try:
            # prepare
            s = vim.current.buffer[line]
            n = line + 1
            # do
            exec(cmd)
            # putback
            vim.current.buffer[n-1] = s
        except Exception:
            if stopWhenError:
                raise
END_OF_PYTHONDO

" funtion for :Pythondo
function PythonDo(line1, line2, pycmd, bang)
    let b:pythondo_cmd = a:pycmd
    exe "python pythondo(" . string(a:line1) . ", " . string(a:line2) . " )"
endfunction

" Command :Pythondo
" <bang>: continue to run py statement even when error occurs
" TODO unimplemented <bang>
"py from pythondo import pythondo
command -range=% -nargs=1 -bang Pythondo call PythonDo(<line1>, <line2>, <q-args>, "<bang>")
command -range=% -nargs=1 -bang Pyd :<line1>,<line2>:Python<bang> <args>

