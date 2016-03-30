\ Forth package manager api
\ (c)copyright 2015 by Gerald Wodni <gerald.wodni@gmail.com>

\ TODO : wrap this into a vocubulary, add sub-vacabularies for each response-type for maximum security

15 constant name-length

\ -- package info --

\ TODO : load wordlist for packages-response
: forth-packages ;

\ TODO : unload wordlist for packages-response
: end-forth-packages ;

\ show package name and description
: name-description ( -- )
    \ name
    vt-bold vt-magenta
    parse-name dup >r type
    \ space
    name-length r> - 1 max spaces
    \ description
    vt-normal
    10 parse type
    vt-color-off
    cr ;

\ -- package download --

: package-content ( <parse-name> <parse-version> -- c-addr-directory n-directory )
    vt-magenta vt-bold ." package-content: "
    vt-normal
    parse-name
    parse-name
    2over type
    ."  v:"
    2dup type
    cr

    fdirectory 2@
    $prefix$name$version+

    vt-color-off ;

: end-package-content ( c-addr-directory n-directory -- )
    drop freet
    vt-magenta vt-bold ." end-package-content" cr
    vt-default ;

: directory ( <parse-directory> -- )
    vt-bold vt-magenta
    ." directory "
    vt-normal
    parse-name \ parse dirname
    2dup type

    vt-white
    bl emit
    2over 2swap $+
    2dup type
    drop freet

    vt-color-off
    cr ;

: file ( <parse-filename> <parse-link> -- )
    vt-bold vt-magenta
    ." file "
    parse-name \ parse filename
    parse-name \ parse link
    2over
    vt-normal
    type bl emit

    api-host http-slurp 200 = if
        vt-white
        2>r rdrop rdrop \ TODO: save content instead of dumping it

        \ get path
        2over 2swap $+
        2dup type
        drop freet

        vt-bold vt-yellow
        ." > "
        vt-magenta
        \ TODO : save into file, oposite of slurp, burp?
    else
        vt-bold vt-red
        . type
        2drop
    then

    vt-default cr ;
