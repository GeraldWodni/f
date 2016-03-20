\ Forth package manager for theForthNet
\ (c)copyright 2015 by Gerald Wodni <gerald.wodni@gmail.com>

\ --- HTTP Client ---
\ if you want your system to support f, define the following words:
\ http-slurp ( c-addr len -- c-addr len )

\ until the major systems support us, we are stuck with this ugly include mess:

\ gforth
: http-gforth if s" http-gforth.4th" required then ;
[DEFINED] gforth http-gforth

\ check if the http-client is now defined, if not there isn't much we can do about it :(
: try-n-die ( f -- )
    0= if cr ." HTTP-client not implemented, system currently not supported" quit then ;
[DEFINED] http-slurp try-n-die

include vt100.4th
include api.4th

: freet free throw ;

\ perform http-get on url and evaluate result
: api-get ( c-addr n xt-ok xt-err -- )
    >r >r
    s" theforth.net" http-slurp dup 200 <> if
        cr ." HTTP-Error: " . cr
        over -rot rdrop r> execute freet
    else
        drop \ response code
        cr
        over -rot r> execute rdrop freet
    then ;

: api-get-eval ( c-addr n -- )
    ['] evaluate ['] type api-get ;

\ list all packages
: fall ( -- )
    s" /api/packages/forth" api-get-eval ;

\ search package name and descriptions
: api-parse-name ( c-addr n xt <parse-name> -- )
    >r parse-name ?dup 0= if
        2drop drop rdrop
        vt-red ." ERROR: no string given" vt-color-off
    else
        $+
        over -rot r> execute
        freet \ free constructed url
    then ;

: fsearch ( <parse-name> -- )
    s" /api/packages/search/forth/"
    ['] api-get-eval api-parse-name ;

\ display information about a package
: finfo-err ( c-addr n -- )
    2drop vt-red ." ERROR: not found" vt-color-off ;
: finfo-ok ( c-addr n -- )
    vt-magenta type vt-color-off ;
: finfo-get ( c-addr n -- )
    ['] finfo-ok ['] finfo-err api-get ;

: finfo ( <parse-name> -- )
    s" /api/packages/info/forth/"
    ['] finfo-get api-parse-name ;

\ download a package

\ add name and version separated by to prefix '/'
: $prefix$name$version+ ( c-addr-name n-name c-addr-version n-version c-addr-prefix n-prefix -- c-addr4 n4 )
    locals| n-prefix c-prefix n-version c-version n-name c-name |
    n-name n-version + n-prefix + 1+ dup            \ total length
    allocate throw                                  \ receiving buffer
    swap
    2>r
    c-prefix 2r@ drop n-prefix cmove                \ write prefix
    c-name 2r@ drop n-prefix + >r r@ n-name cmove   \ write name
    [CHAR] / r> n-name + >r r@ c!                   \ write slash
    c-version r> 1+ n-version cmove                 \ write version
    2r> ; \ final path

\ search package name and descriptions
: api-parse-name-version ( c-addr n xt <parse-name> <parse-version> -- )
    >r 2>r parse-name ?dup 0= if \ parse name
        drop rdrop 2rdrop
        vt-red ." ERROR: no name given" vt-color-off
    else
        parse-name ?dup 0= if \ parse version
            2drop drop rdrop 2rdrop
            vt-red ." ERROR: no version given" vt-color-off
        else
            2r>
            $prefix$name$version+
            over -rot r> execute
            freet \ free constructed url
        then
    then ;

: fget-get ( c-addr-path n-path -- )
    ." FGET" cr
    type cr
    ;

: fget ( <parse-name> <parse-version> -- )
    s" /api/packages/content/forth/"
    ['] api-get-eval api-parse-name-version ;
