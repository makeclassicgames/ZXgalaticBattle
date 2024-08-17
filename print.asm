;Imprime una cadena por pantalla
PrintString:
ld a,(hl)
rst $10
inc hl
djnz PrintString
ret

; Print frame screen
PrintFrame:
ld hl, frameTopGraph
ld b,frameEnd-frameTopGraph
call PrintString
ld b,$01
;print lateral frames
printframe_loop:
ld a,$16
rst $10
ld a,b
rst $10
ld a,$00
rst $10
ld a,$99
rst $10
ld a,$16
rst $10
ld a,b
rst $10
ld a,$1f
rst $10
ld a,$9a
rst $10
inc b
ld a,b
cp $15
jr nz,printframe_loop
ret

printInfoGame:
ld a,$01
call OPENCHAN
ld hl,infoGame
ld b, infoGame_end - infoGame
call PrintString
ld a,$02
call OPENCHAN
ret