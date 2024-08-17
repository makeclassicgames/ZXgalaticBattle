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
main_loop:
jr main_loop
ret

include "Const.asm"
include "Var.asm"
include "graph.asm"
include "print.asm"
end main