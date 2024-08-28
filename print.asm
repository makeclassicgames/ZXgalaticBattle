;Imprime una cadena por pantalla
PrintString:
ld a,(hl) ; cargar el valor de la direccion que hay en HL en a
rst $10 ; imprimir caracter
inc hl ; incrementar hl
djnz PrintString ; si no ha acabado, volver a imprimir
ret ; fin de la rutina

;imprimir frame
; Print frame screen
PrintFrame:
ld hl, frameTopGraph ;carga graficos superior e inferior
ld b,frameEnd-frameTopGraph ;contador de bytes
call PrintString ;imprimir cadena
ld b,COR_Y-$01 ; carga posicion y -1
;print lateral frames
printframe_loop: ;bucle pintado lateral
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

printInfoGame:
ld a,$01
call OPENCHAN
ld hl,infoGame
ld b, infoGame_end-infoGame
call PrintString
ld a,$02
call OPENCHAN

deleteChar:
call at
ld a,WHITE_GRAPH
rst $10
ret

printShip:
ld a,$07
call ink
ld bc,(shipPos)
call at
ld a, SHIP_GRAPH
rst $10
ret

;Dibuja el disparo
printFire:
ld a,$02
call ink
ld bc,(firePos)
call at
ld a, FIRE_GRAPH
rst $10
ret