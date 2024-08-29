;rutina movimiento nave
moveShip:
ld hl,flags
bit $00,(hl)
ret z
res $00,(hl)
;carga de la nave
ld bc,(shipPos)
bit $01,d
jr nz, moveShip_right
bit $00,d
ret z
;Mover nave a la derecha
moveShip_left:
ld a,SHIP_TOP_L+$01
sub c
ret z
call deleteChar
inc c
ld (shipPos),bc
jr moveShip_print
;mover nave a la izquierda
moveShip_right:
ld a,SHIP_TOP_R+$01
sub c
ret z
call deleteChar
dec c
ld (shipPos),bc
;mostrar nave
moveShip_print:
call printShip
ret

;Mover disparo
moveFire:
ld hl,flags
bit $01,(hl)
jr nz,moveFire_try
bit $02,d
ret z
set $01,(hl)
ld bc,(shipPos)
inc b
jr moveFire_print
moveFire_try:
ld bc,(firePos)
call deleteChar
inc b
ld a,FIRE_TOP_T
sub b
jr nz,moveFire_print
ret

moveFire_print:
ld (firePos),bc
call printFire
ret

; -----------------------------------------------------------------------------
; Mueve los enemigos.
;
; Altera el valor de lo registros AF, BC, D y HL.
; -----------------------------------------------------------------------------
MoveEnemies:
ld      hl, flags           ; Cargamos la dirección de memoria de flags en HL
bit     $02, (hl)           ; Comprueba si el bit 2 está activo
ret     z                   ; Si no es así, sale                
res     $02, (hl)           ; Desactiva el bit 2 de flags

ld      d, $14              ; Carga en D el número total de enemigos (20)
ld      hl, enemiesConfig   ; Cara en HL la dirección de la configuración 
                            ; de los enemigos
moveEnemies_loop:
bit     $07, (hl)           ; Comprueba si el enemigo está activo
jr      z, moveEnemies_endLoop  ; Si no lo está, salta a final del bucle

push    hl                  ; Preserva el valor de HL

ld      a, (hl)             ; Carga en A el primer byte de la cofiguración
and     $1f                 ; Se queda con la coordenada Y
ld      b, a                ; Carga el valor en B

inc     hl                  ; Apunta HL al segundo byte de la configuración
ld      a, (hl)             ; Carga el valor en A
and     $1f                 ; Se queda con la coordeanda X
ld      c, a                ; Carga el valor en C

call    deleteChar          ; Borra el enemigo

pop     hl                  ; Recupera el valor de HL

ld      b, (hl)             ; Carga en B el primer byte de la configuración
inc     hl                  ; Apunta HL al segundo byte de la configuración
ld      c, (hl)             ; Carga en C el segundo byte de la configuración

moveEnemies_X:
ld      a, c                ; Carga en A el segundo byte de la configuración
and     $1f                 ; Se queda con la coordeada X

bit     $06, c              ; Evalúa la dirección horizontal del enemigo
jr      nz, moveEnemies_X_right ; Si está a uno, hacia la derecha, salta

moveEnemies_X_left:
inc     a                   ; Apunta A a la columna anterior 
sub     ENEMY_TOP_L         ; Resta el tope por la izquierda
jr      z, moveEnemies_X_leftChg    ; Si es cero, ha llegado al tope, salta

inc     c                   ; Apunta C a la columna anterior
jr      moveEnemies_Y       ; Salta al movimiento vertical 

moveEnemies_X_leftChg:
set     $06, c              ; Pone la dirección horizontal hacia la derecha
jr      moveEnemies_Y       ; Salta al movimiento vertical

moveEnemies_X_right:
dec     a                   ; Apunta A a la columna posterior
sub     ENEMY_TOP_R         ; Resta el tope por la derecha
jr      z, moveEnemies_X_rightChg   ; Si es cero, ha llegado al tope, salta

dec     c                   ; Apunta C a la columna posterior
jr      moveEnemies_Y       ; Salta al movimiento vertical

moveEnemies_X_rightChg:
res     $06, c              ; Pone la dirección horizontal hacia la izquierda

moveEnemies_Y:
ld      a, b                ; Carga en A el primer byte de la configuración
and     $1f                 ; Se qued con la coordenda Y
bit     $07, c              ; Evalúa la dirección vertical del enemigo
jr      nz, moveEnemies_Y_down  ; Si está a uno, hacia abajo, salta

moveEnemies_Y_up:
inc     a                   ; Apunta A a la línea anterior
sub     ENEMY_TOP_T         ; Resta el tope por arriba
jr      z, moveEnemies_Y_upChg  ; Si es cero, ha llegado al tope, salta

inc     b                   ; Apunta B a la línea posterior
jr      moveEnemies_endMove ; Salta al final del bucle

moveEnemies_Y_upChg:
set     $07, c              ; Pone la dirección vertical hacia abajo
jr      moveEnemies_endMove ; Salta al final del bucle

moveEnemies_Y_down:
dec     a                   ; Apunta A a la línea posterior
sub     ENEMY_TOP_B         ; Resta el tope por abajo
jr      z, moveEnemies_Y_downChg    ; Si es cero, ha llegado al tope, salta

dec     b                   ; Apunta B a la línea posterior
jr      moveEnemies_endMove ; Salta al final del bucle

moveEnemies_Y_downChg:
res     $07, c              ; Pone la dirección vertical hacia arriba

moveEnemies_endMove:
ld      (hl), c             ; Actualiza el segundo byte de la configuración
dec     hl                  ; Apunta HL al primer byte de la configuración
ld      (hl), b             ; Actualiza el primer byte de la configuración

moveEnemies_endLoop:
inc     hl
inc     hl                  ; Aputa HL al primer byte de la configuración
                            ; del siguiente enemigo
dec     d                   ; Decrementa D
jr      nz, moveEnemies_loop    ; Hasta que D sea cero (20 enemigos)

moveEnemies_end:
call    printEnemies        ; Pinta los enemigos

ret