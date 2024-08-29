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

; -----------------------------------------------------------------------------
; Pinta los enemigos
;
; Altera el valor de los registros AF, BC, D y HL.
; -----------------------------------------------------------------------------
printEnemies:
ld      a, $06                      ; Carga en A la tinta amarilla        
call    ink                         ; Cambia la tinta

ld      hl, enemiesConfig           ; Carga la dirección de la configuración 
                                    ; del enemigo en HL
ld      d, $14                      ; Carga en D 20 enemigos

printEnemies_loop:
bit     $07, (hl)                   ; Evalúa si el enemigo está activo
jr      z, printEnemies_endLoop     ; Si no lo está, salta

push    hl                          ; Preserva el valor de HL

ld      a, (hl)                     ; Carga el primer byte de configuración en A
and     $1f                         ; Se queda con la coordenda Y
ld      b, a                        ; La carga en B

inc     hl                          ; Apunta HL al segundo byte
ld      a, (hl)                     ; Carga el valor en A
and     $1f                         ; Se queda con la coordenada X
ld      c, a                        ; La carga en C
call    at                          ; Posiciona el cursor

ld      a, (hl)                     ; Vuelve a cargar el segudo byte en A
and     $c0                         ; Se queda con la dirección (izquierda ...)
rlca                                ; Pone el valor en los bits 0 y 1
rlca
ld      c, a                        ; Carga el valor en C
ld      b, $00                      ; Pone B a cero

ld      hl, enemiesGraph            ; Carga en HL el carácter del gráfico del enemigo
add     hl, bc                      ; Le suma la dirección de enemigo (izquierda ...)
ld      a, (hl)                     ; Carga en A el gráfico del enemigo
rst     $10                         ; Lo pinta

pop      hl                         ; Recupera el valor de HL

printEnemies_endLoop:
inc     hl                          ; Apunta HL al primer byte de la configuración
inc     hl                          ; del enemigo siguientes

dec     d                           ; Decrementa D
jr      nz, printEnemies_loop       ; hasta que D sea 0

ret