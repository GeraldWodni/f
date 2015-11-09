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

\ list all packages
: fall ( -- )
    s" /api/packages/forth" s" theforth.net" http-slurp dup 200 <> if
        cr ." HTTP-Error: " . cr
        over -rot type free
    else
        drop \ response code
        cr
        over -rot evaluate \ free
    then
    ;

\ --- Search ---

