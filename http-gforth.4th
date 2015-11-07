\ HTTP client implementation for GForth
\ This is a very hacky implementation, but it works.
\ (c)copyright 2015 by Gerald Wodni <gerald.wodni@gmail.com>

include unix/socket.fs

8000 constant http-port
1 constant buffer-max       \ receiving buffer length ( yes we only care about single chars )
buffer-max buffer: buffer   \ receiving buffer
variable buffer-len         \ chars in receiving buffer

\ data in receiving socket
: skey? ( socket -- f )
    buffer-len @ 0<> ;

\ attempt to refill
: (srefill) ( socket -- )
    buffer buffer-max read-socket nip buffer-len ! ;

\ make sure we refill and get at least 1 char
: srefill ( socket -- )
    begin
        skey? 0=
    while
        dup (srefill)
    repeat drop ;

\ read char from socket
: skey ( socket -- c )
    srefill buffer c@
    0 buffer-len ! ;

\ strip \r
: skey-no\r ( socket -- c )
    begin
        dup skey dup 13 =
    while
        drop
    repeat nip ;

: sline ( c-addr n socket -- n )
    -rot    \ save socket
    over >r \ save buffer
    bounds do
        dup skey-no\r dup 10 = if \ leave on newline
            2drop i leave \ push current buffer-offset
        then
        i c!
    loop
    r@ - r> swap ; \ return buffer with read size

80 constant slines-max
slines-max buffer: slines-buffer
: slines ( socket -- )
    1000 0 do
        dup >r slines-buffer slines-max r> sline ." LINE:" type cr
    loop drop ;

: http-open ( c-addr-path n-path c-addr-host n-host -- c-addr-response n-response )
    2dup \ save host
    http-port open-socket >r
        s" GET " r@ write-socket    \ start get request
        2swap r@ write-socket       \ send path 
        s\"  HTTP/1.1\r\nHost: " r@ write-socket
        r@ write-socket             \ send host
        s\" \r\nConnection: Close\r\n\r\n" r@ write-socket
        r>
    ;

s" /" s" localhost.theforth.net" http-open constant s
s slines

\ s" 0123456789" 2constant x

\ x s sline

." RDY!" cr 

\ bye
