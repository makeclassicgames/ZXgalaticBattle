ORG $5dad; compatible with 16K

main:
ld a,$02
CALL OPENCHAN
ld hl, udgsCommon
ld (UDG),hl
ld hl, ATTR_P
ld hl,$07
call CLS
xor a
out ($fe),a
ld a, (BORDCR)
and $c7
or $07
ld (BORDCR),a
call PrintFrame
call printInfoGame
call printShip
main_loop:
call checkCtrl
call moveShip
jr main_loop
ret

include "Const.asm"
include "Var.asm"
include "graph.asm"
include "print.asm"
include "ctrl.asm"
include "game.asm"
end main