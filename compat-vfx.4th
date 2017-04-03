\ HTTP client implementation for VFX
\ (c)copyright 2017 by Gerald Wodni <gerald.wodni@gmail.com>

[defined] target_386_windows [if]
include %vfxpath%\Lib\Win32\Genio\SocketIo.fth
[then]
[defined] target_386_linux [if]
include %vfxpath%/Lib/Lin32/Genio/SocketIo.fth
include %vfxpath%/Lib/Lin32/MultiLin32.fth
[then]
[defined] target_arm_linux [if]
include %vfxpath%/Lib/Lin32/Genio/SocketIo.fth
[then]

80 constant http-port
1 constant buffer-max       \ receiving buffer length ( yes we only care about single chars )
buffer-max buffer: rbuffer  \ receiving buffer
variable buffer-len         \ chars in receiving buffer

: rdrop ( -- R: x -- )
    POSTPONE r> POSTPONE drop ; immediate

: 2rdrop ( -- R: x1 x2 -- )
    POSTPONE r> POSTPONE drop POSTPONE r> POSTPONE drop ; immediate

\ attempt to refill
: (srefill) ( socket -- )
    >r rbuffer buffer-max r> readsock throw nip buffer-len ! ;

: write-socket ( c-addr n sock -- )
    writesock throw drop ;

: http-open ( c-addr-path n-path c-addr-host n-host -- socket )
    2dup \ save host
    tcpconnect http-port >r
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

    r> closesocket throw
    r> \ status
    ;


\ directories
: create-directories ;
\ : create-directories ( c-addr n -- ior )
\     $1FF mkdir-parents      \ add mask
\     dup error-exists = if   \ ignore error-exists
\         drop 0
\     then ;
