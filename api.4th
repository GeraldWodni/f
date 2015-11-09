\ Forth package manager api
\ (c)copyright 2015 by Gerald Wodni <gerald.wodni@gmail.com>

\ TODO : wrap this into a vocubulary, add sub-vacabularies for each response-type for maximum security

15 constant name-length

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
