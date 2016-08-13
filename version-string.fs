\ Forth package manager version utils
\ (c)copyright 2016 by Gerald Wodni <gerald.wodni@gmail.com>

\ convert version-string to number (3 digits per version-part)

include test/ttester.fs

: vers>str ( c-addr n-len -- n-vers )
    0.0 2swap       \ startup value
    >number         \ parse major
    1- swap 1+ swap \ advance string
    2>r 0.0 2r>     \ save number
    >number         \ parse minor
    1- swap 1+ swap \ advance string
    2>r 0.0 2r>     \ save number
    >number         \ parse patch
    2drop           \ cleanup
    drop >r
    drop 1000 * >r
    drop 1000000 *
    r> + r> + ;

T{ s" 123.456.789" vers>str -> 123456789 }T
T{ s" 1.234.5" vers>str -> 1234005 }T
T{ s" 1.2.3" vers>str -> 1002003 }T
T{ s" 123.4.5" vers>str -> 123004005 }T
T{ s" 1.0.0 vers>str -> 1000000 }T
T{ s" 0.1.0 vers>str -> 1000 }T
T{ s" 0.0.1 vers>str -> 1 }T
T{ s" 1.0.2 vers>str -> 1000002 }T
T{ s" 1.2.0 vers>str -> 1002000 }T
T{ s" 1.2.0 vers>str -> 1002000 }T

