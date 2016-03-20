\ add 2 strings to path separated by '/'
: fget-merge ( c-addr-name n-name c-addr-version n-version c-addr-prefix n-prefix -- c-addr4 n4 )
    ~~
    locals| n-prefix c-prefix n-version c-version n-name c-name |
    c-prefix n-prefix type cr
    c-name n-name type cr
    c-version n-version type cr

    n-name n-version + n-prefix + 1+ dup            \ total length
    allocate throw                                  \ receiving buffer
    swap
    ~~
    2>r
    c-prefix 2r@ drop n-prefix cmove                \ write prefix
    c-name 2r@ drop n-prefix + >r r@ n-name cmove   \ write name
    [CHAR] / r> n-name + >r r@ c!
    c-version r> 1+ n-version cmove
    \ c-version 2r@ drop n-prefix + n-name cmove      \ write name
    2r> ; \ final path

s" euler303" s" current" s" /api/packages/content/forth/" fget-merge
type cr
