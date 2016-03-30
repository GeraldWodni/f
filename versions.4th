\ Forth package manager version utils
\ (c)copyright 2016 by Gerald Wodni <gerald.wodni@gmail.com>

\ as Forth has no standardized way to interface with directories,
\ versions-numbers are stored in a version-file which contains
\ one entry per line. This avoids the need to read a directory

: open-or-create ( c-addr-path n-path -- fid ior )
    \ file exists and can be reopened
    2dup w/o open-file ?dup 0= if
        >r
        r@ file-size throw  \ get last byte
        r@ reposition-file  \ move file pointer there
        nip nip             \ remove path
        r> swap exit        \ return fid ior
    then
    \ otherwise create file
    2drop
    w/o create-file ;

\ open or create file and add line
: append-to-file ( c-addr-line n-line c-addr-path n-path -- ior )
    open-or-create throw
    >r r@ write-line throw
    r> close-file ;

\ s" 1.2.4" s" vers" append-to-file throw

256 constant max-line
max-line 2 + buffer: line-buffer

\ checking every line for a match
: scan-lines ( c-addr-line n-line fid -- f )
    >r
    begin
        line-buffer max-line r@ read-line throw
    while
        >r 2dup line-buffer r> compare 0=
        until
        2drop true
    else
        drop
        2drop false
    then rdrop ;

\ check if line is inside of file
: line-in-file ( c-addr-line n-line c-addr-path n-path -- f )
    r/o open-file if \ if file does not exist, return false
        false exit
    then
    >r r@ scan-lines
    r> close-file throw ;
