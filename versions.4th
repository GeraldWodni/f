\ Forth package manager version utils
\ (c)copyright 2016 by Gerald Wodni <gerald.wodni@gmail.com>

\ as Forth has no standardized way to interface with directories,
\ versions-numbers are stored in a version-file which contains
\ one entry per line. This avoids the need to read a directory

\ TODO: merge err-exits into single word ( n*x n ior -- ior | n*x )
\ exit current word and leave ior on stack if ior is non-zero
: err-exit immediate ( ior -- ior| )
    POSTPONE ?dup POSTPONE 0<> POSTPONE if POSTPONE exit POSTPONE then ;

: err-exit-drop1 immediate ( x ior -- ior|x )
    POSTPONE ?dup POSTPONE 0<> POSTPONE if POSTPONE nip POSTPONE exit POSTPONE then ;

: err-exit-drop2 immediate ( x ior -- ior|x )
    POSTPONE ?dup POSTPONE 0<> POSTPONE if POSTPONE nip POSTPONE nip POSTPONE exit POSTPONE then ;

: open-or-create ( c-addr-path n-path -- fid ior )
    \ file exists and can be reopened
    ~~
    2dup w/o open-file ~~ ?dup 0= if
    ~~
        dup ~~ file-size ~~ err-exit-drop1    \ forward to eof
        ~~
        over ~~ reposition-file ~~ exit       \ return ior
    then
    ~~
    \ otherwise create file
    2drop ~~
    w/o ~~ create-file ;

\ open or create file and add content
: append-to-file ( c-addr-content n-content c-addr-path n-path -- ior )
    ." OPENING..."
    open-or-create throw
    ." ALL DONE!"
    close-file ;

s" 1.2.3" s" vers" append-to-file


