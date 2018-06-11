#! /usr/bin/env gforth
warnings off

include ../mf/mf.f

                 64 constant /line
                 16 constant lines/block
/line lines/block * constant /block

create line /line allot

: open    ( a n -- fd )  r/o open-file throw ;
: size    ( fd -- n )    file-size throw d>s ;
: blocks  ( fd -- n )    size /block / ;
: read    ( fd -- )
  push line /line pop read-file throw
  /line <> abort" short read" ;

: line>text   ( fd -- )  read line /line -trailing type ;
: block>text  ( fd -- )  lines/block for dup cr line>text next ;

\ assumes a has the current block number
: block#  ( -- n )  a dup 1+ a! ; 

: fd>text   ( fd -- )
  1 a!  dup blocks for
    ." \ --- Block "  block# .  ." --- "
    block>text
    cr
  next ;


: usage  ." usage: scr2text file" cr bye ;
: main
  argc @ 1 <= if drop usage then drop
  1 arg open fd>text bye ;

main
