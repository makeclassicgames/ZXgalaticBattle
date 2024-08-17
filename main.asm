ORG $5dad; compatible with 16K

main:
Main:
ld      a, $02
call    OPENCHAN

ld      hl, udgsCommon
ld      (UDG), hl

ld      hl, ATTR_P
ld      (hl), $07
call    CLS

xor     a
out     ($fe), a
ld      a, (BORDCR)
and     $c7
or      $07
ld      (BORDCR), a

call    PrintFrame
call    printInfoGame
call    printShip

Main_loop:
call    checkCtrl
call    moveShip
jr      Main_loop
ret

include "Const.asm"
include "Var.asm"
include "graph.asm"
include "print.asm"
include "ctrl.asm"
include "game.asm"
end main