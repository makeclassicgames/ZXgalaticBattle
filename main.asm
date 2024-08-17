ORG $5dad; compatible with 16K

main:
ld a,$02
CALL OPENCHAN
ld hl, udgsCommon
ld (UDG),hl
ld a,$90
ld b,$0f
Loop:
push af
rst $10
pop af
inc a
djnz Loop
ld a,$01
ld b,$1e
Loop2:
push af
push bc
call LoadUdgsEnemies
ld a,$9f
rst $10
ld a, $a0
rst $10
ld a,$a1
rst $10
ld a,$a2
rst $10
pop bc
pop af
djnz Loop2
ld hl,Cadena
ld b,cadena_fin - Cadena
call PrintString
ret
Cadena: db $16,$0a,$0a,'Hola Mundo'
cadena_fin: db $
include "Const.asm"
include "Var.asm"
include "graph.asm"
include "print.asm"
end main