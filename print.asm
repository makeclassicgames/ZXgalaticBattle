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
ld b,COR_Y-$01
;print lateral frames
printframe_loop:
ld c,COR_X-MIN_X
call at
ld a,$99
rst $10
ld c,COR_X-MAX_X
call at
ld a,$9a
rst $10
dec b
ld a,COR_Y-MAX_Y+$01
sub b
jr nz,printframe_loop
ret

;rutina imprimir informacion juego
printInfoGame:
ld a,$01
call OPENCHAN
ld hl,infoGame
ld b, infoGame_end - infoGame
call PrintString
ld a,$02
call OPENCHAN
ret
;Borrar un caracter
deleteChar:
call at
ld a, WHITE_GRAPH
rst $10
ret
;Rutina imprimir nave
printShip:
ld      a, $07          ; Carga en A la tinta blanca
call    ink             ; Llama al cambio de tinta

ld      bc, (shipPos)   ; Carga en BC la posición actual de la nave
call    at              ; Llama a posicionar el cursor

ld      a, SHIP_GRAPH   ; Carga en A el carácter de la nave
rst     $10             ; La pinta

ret