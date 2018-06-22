#! /usr/bin/env gforth
warnings off

require ../mf/mf.f

                 64 constant /line
                 16 constant lines/block
/line lines/block * constant /block

create block /block allot

: .header  ( n -- )  ." ( -- BLOCK "  .  ." -- )" ;
: line#    ( n -- )  lines/block swap - ;
: line     ( n -- )  line# /line *  block + ;
: .line    ( n -- )  line /line -trailing type ;
: .block             lines/block for i .line cr next ;

: open  ( a n -- fd )  r/o open-file throw ;
: read  ( fd -- n )    push block /block pop read-file throw  /block = ;

: .blocks  ( fd -- )
  1 begin over read while dup .header 1+ cr .block repeat drop drop ;

: usage  ." usage: scr2text file" cr ;
: main   argc @ 1 > if 1 arg open else stdin then .blocks ;

main
bye
