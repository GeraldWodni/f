\ HTTP client implementation for GForth
\ (c)copyright 2015-2016 by Gerald Wodni <gerald.wodni@gmail.com>

include unix/socket.fs

80 constant http-port
1 constant buffer-max       \ receiving buffer length ( yes we only care about single chars )
buffer-max buffer: rbuffer  \ receiving buffer
variable buffer-len         \ chars in receiving buffer

\ attempt to refill
: (srefill) ( socket -- )
    rbuffer buffer-max read-socket nip buffer-len ! ;

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

include compat-common.4th

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


\ directories
: create-directories ( c-addr n -- ior )
    $1FF mkdir-parents      \ add mask
    dup error-exists = if   \ ignore error-exists
        drop 0
    then ;
