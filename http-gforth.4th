\ HTTP client implementation for GForth
\ This is a very hacky implementation, but it works.
\ (c)copyright 2015 by Gerald Wodni <gerald.wodni@gmail.com>

include unix/socket.fs

8000 constant http-port
1 constant buffer-max       \ receiving buffer length ( yes we only care about single chars )
buffer-max buffer: rbuffer  \ receiving buffer
variable buffer-len         \ chars in receiving buffer

\ some helpers
: str>num ( c-addr n -- n )
    2>r 0 0 2r> >number 2drop drop ;

: str-to-lower ( c-addr n -- c-addr n )
    2dup bounds ?do
        i c@ dup [CHAR] A >= over [CHAR] Z <= and if
            $20 + i c!
        else
            drop
        then
    loop ;

: skip-bl ( c-addr n -- c-addr 2 n2 )
    2>r \ save start address
    2r@ bounds do
        i c@ bl <> if
            i leave
        then
    loop 2r>
    >r over swap - r> \ number of skipped blanks
    swap - ; \ change length

\ data in receiving socket
: skey? ( socket -- f )
    buffer-len @ 0<> ;

\ attempt to refill
: (srefill) ( socket -- )
    rbuffer buffer-max read-socket nip buffer-len ! ;

\ make sure we refill and get at least 1 char
: srefill ( socket -- )
    begin
        skey? 0=
    while
        dup (srefill)
    repeat drop ;

\ read char from socket
: skey ( socket -- c )
    srefill rbuffer c@
    0 buffer-len ! ;

\ strip \r
: skey-no\r ( socket -- c )
    begin
        dup skey dup 13 =
    while
        drop
    repeat nip ;

: sline ( c-addr n socket -- c-addr n )
    -rot    \ save socket
    over >r \ save buffer
    bounds do
        dup skey-no\r dup 10 = if \ leave on newline
            2drop i leave \ push current buffer-offset
        then
        i c!
    loop
    r@ - r> swap ; \ return buffer with read size

\ I might fall for locals some day, this is far easier than plain sline
: sline-until { c-addr-buf n-buf socket c-until -- c-addr n }
    c-addr-buf n-buf bounds do
        socket skey-no\r dup c-until = over 10 = or if
            drop i leave
        then
        i c!
    loop
    c-addr-buf - c-addr-buf swap ;

80 constant header-max
header-max buffer: header-buffer

: header-buf ( s -- c-addr n s )
    >r header-buffer header-max r> ;

: header-line ( s -- c-addr n )
    header-buf sline ;

: header-name ( s -- c-addr n )
    header-buf [CHAR] : sline-until str-to-lower ;

: http-status ( s -- n )
    header-line s"  " search if
        3 >= if
            1+ 3 str>num
        else \ return one on invalid string length
            1
        then
    else \ return zero if no space was found
        0
    then ;

80 constant slines-max
slines-max buffer: slines-buffer
: slines ( socket -- )
    101 0 do
        dup >r slines-buffer slines-max r> sline ." LINE:" i . type cr
    loop drop ;

: http-open ( c-addr-path n-path c-addr-host n-host -- socket )
    2dup \ save host
    http-port open-socket >r
        s" GET " r@ write-socket    \ start get request
        2swap r@ write-socket       \ send path 
        s\"  HTTP/1.1\r\nHost: " r@ write-socket
        r@ write-socket             \ send host
        s\" \r\nConnection: Close\r\n\r\n" r@ write-socket
        r>
    ;

\ parse all headers and return content length
: http-length ( s -- n-content-length )
    0
    locals| length |
    begin
        dup header-name
        dup 0<>
    while
        s" content-length" compare 0= if
            dup header-line
            skip-bl str>num to length
        else
            dup header-line 2drop
        then
    repeat 2drop drop length ;

: http-body ( socket c-addr n -- )
    bounds ?do
        dup skey i c!
    loop drop ;

: http-slurp ( c-addr-path n-path c-addr-host n-host -- c-addr-response n-response n-status )
    http-open
    dup http-status >r

    >r \ socket
    
    r@ http-length
    dup allocate throw swap \ c-addr n-len

    2dup r@ -rot http-body  \ read body into buffer

    r> close-socket
    r> \ status
    ;


s" /" s" localhost.theforth.net" http-slurp
." AFTER SLURP:
.s

." RDY!" cr 

