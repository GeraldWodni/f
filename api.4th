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
    vt-default
    10 parse type
    vt-color-off
    cr ;

\ -- package download --

: package-content ( <parse-name> <parse-version> -- )
    vt-magenta vt-bold ." package-content: "
    vt-default
    parse-name type
    ."  v:"
    parse-name type cr
    vt-color-off ;

: end-package-content
    vt-magenta vt-bold ." end-package-content" cr
    vt-default vt-color-off ;

: directory ( <parse-directory> -- )
    vt-bold vt-magenta
    ." directory "
    vt-default
    parse-name type
    vt-color-off
    cr ;

: file ( <parse-filename> <parse-link> -- )
    vt-bold vt-magenta
    ." file "
    vt-default
    parse-name type
    vt-bold ."  -> " vt-default
    parse-name type
    vt-color-off
    cr ;
