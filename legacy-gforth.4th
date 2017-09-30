/ This file implements words that may be missing in GForth <= 0.7.3
/ All words referenced from `forth-standard.org`

/ GForth 0.7.3 does not implement `BUFFER:`
/ ==========================================

: BUFFER: ( u "<name>" -- ; -- addr )
   CREATE ALLOT
;

/ GForth 0.7.3 does not implement quotations
/ ==========================================

12345 CONSTANT undefined-value
: match-or-end? ( c-addr1 u1 c-addr2 u2 -- f )
   2 PICK 0= >R COMPARE 0= R> OR ;

: scan-args
   \ 0 c-addr1 u1 -- c-addr1 u1 ... c-addrn un n c-addrn+1 un+1
   BEGIN
    	2DUP S" |" match-or-end? 0= WHILE
    	2DUP S" --" match-or-end? 0= WHILE
    	2DUP S" :}" match-or-end? 0= WHILE
    	ROT 1+ PARSE-NAME
   AGAIN THEN THEN THEN ;

: scan-locals
   \ n c-addr1 u1 -- c-addr1 u1 ... c-addrn un n c-addrn+1 un+1
   2DUP S" |" COMPARE 0= 0= IF
    	EXIT
   THEN
   2DROP PARSE-NAME
   BEGIN
    	2DUP S" --" match-or-end? 0= WHILE
    	2DUP S" :}" match-or-end? 0= WHILE
    	ROT 1+ PARSE-NAME
    	POSTPONE undefined-value
   AGAIN THEN THEN ;

: scan-end ( c-addr1 u1 -- c-addr2 u2 )
   BEGIN
    	2DUP S" :}" match-or-end? 0= WHILE
    	2DROP PARSE-NAME
   REPEAT ;

: define-locals ( c-addr1 u1 ... c-addrn un n -- )
   0 ?DO
    	(LOCAL)
   LOOP
   0 0 (LOCAL) ;

: {: ( -- )
   0 PARSE-NAME
   scan-args scan-locals scan-end
   2DROP define-locals
; IMMEDIATE

