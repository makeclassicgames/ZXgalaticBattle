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

call    DeleteChar          ; Borra el enemigo

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
call    PrintEnemies        ; Pinta los enemigos

ret

; ----------------------------------------------------------------------------
; Mueve el disparo
;
; Entrada:  D -> Estado de los controles
; Altera el valor de los registros AF, BC y HL.
; ----------------------------------------------------------------------------
MoveFire:
ld      hl, flags           ; Carga en HL la dirección de memoria de flags
bit     $01, (hl)           ; Evalúa si el bit del disparo está activo
jr      nz, moveFire_try    ; Si está activo, salta
bit     $02, d              ; Evalúa si el control de disparo está activo
ret     z                   ; Si no está activo, sale
set     $01, (hl)           ; Activa el bit del disparo en flags
ld      bc, (shipPos)       ; Carga la posición actual de la nave en HL
inc     b                   ; Apunta a la línea superior
jr      moveFire_print      ; Salta a pintar el diparo

moveFire_try:
ld      bc, (firePos)       ; Carga en BC la posición actual del disparo
call    DeleteChar          ; Borra el disparo
inc     b                   ; Apunta B a la línea superior
ld      a, FIRE_TOP_T       ; Carga en A el tope superior del disparo
sub     b                   ; Le restamos coordenada Y del disparo
jr      nz, moveFire_print  ; Si son distintos, no ha llegado al tope, salta
res     $01, (hl)           ; Desactiva el disparo

ret

moveFire_print:
ld      (firePos), bc       ; Actualiza la posición del disparo
call    PrintFire           ; Pinta el disparo

ret

; -----------------------------------------------------------------------------
; Mueve la nave
;
; Entrada:  D -> Estado de los controles
; Altera el valor de los registros AF y BC
; -----------------------------------------------------------------------------
MoveShip:
ld      hl, flags           ; Cargamos la dirección de memoria de flags en HL
bit     $00, (hl)           ; Comprueba si el bit 0 está activo
ret     z                   ; Si no es así, sale                
res     $00, (hl)           ; Desactiva el bit 0 de flags

ld      bc, (shipPos)       ; Carga la posición actual de la nave en BC
bit     $01, d              ; Comprueba si el control derecha viene activo
jr      nz, moveShip_right  ; En cuyo caso, salta

bit     $00, d              ; Comprueba si el control izquierda viene activo
ret     z                   ; Si no es así, sale

moveShip_left:
ld      a, SHIP_TOP_L + $01 ; Carga en A el tope para la nave por la izquierda
sub     c                   ; Le resta la columna actual de la nave
ret     z                   ; Si es la misma columna, sale
call    DeleteChar          ; Borra la nave de la posición actual
inc     c                   ; Apunta C a la columna a la izquierda a la actual
ld      (shipPos), bc       ; Actualiza la posición de la nave
jr      moveShip_print      ; Salta al final de la rutina

moveShip_right:
ld      a, SHIP_TOP_R + $01 ; Carga en A el tope para la nave por la derecha
sub     c                   ; Le resta la columna actual de la nave
ret     z                   ; Si es la misma columna, sale
call    DeleteChar          ; Borra la nave de la posición actual
dec     c                   ; Apunta C a la culumna a la derecha a la actual
ld      (shipPos), bc        ; Actualiza la posición de la nave

moveShip_print:
call    PrintShip           ; Pintamos la nave

ret

; rutina de comprobacion de colision disparo y enemigos
CheckCrashFire:
ld a,(flags) ; carga flags
and $02      ; Comprueba si esta activo
ret z        ; Si es 0 (no activo), entonce sale
ld de,(firePos) ; carga posicion del disparo
ld hl, enemiesConfig ; carga la configuracion de los enemigos
ld b, enemiesConfigEnd-enemiesConfigIni ; en b  se guarda el numero de bytes
sra b   ; se desplaza b
CheckCrashFire_loop:
ld a,(hl)   ; cargamos la configuracion actual
inc hl      ; pasamos al siguiente byte
bit $07,a   ; cargamos el byte 7
jr z, CheckCrashFire_endLoop   ; si es 0, no esta activo
and $1f     ; obtenemos los datos usando una mascara
cp d        ; se carga en d
jr nz, CheckCrashFire_endLoop   ; si no esta a 0 entonces ir al final
ld a,(hl)   ;cargamos en a la configuracion del enemigo actual
and $1f     ; obtenemos los datos
cp e        ; comparamos con el valor de e
jr nz, CheckCrashFire_endLoop   ; si no es 0, ir al final
dec hl      ; obtenemos el primer byte 
res $07, (hl)   ;obtenemos el byte 7 almacenado en hl para saber posicion
ld b,d          ; carga d en b
ld c,e          ; carga e en c
call DeleteChar ; borramos caracter en la posicion del enemigo

ld hl,(enemiesCounter)    ; cargamos contador
dec a   ;decrementar a
daa 
ld (enemiesCounter),a
ld a, (pointsCounter)
add a,$05
daa
ld (pointsCounter),a
ld a,(pointsCounter)
ld a,(pointsCounter+1)
add a,$00
daa
ld (pointsCounter+1),a
call printInfoValue
dec (hl)    ;decrementamos contador
ret         ;salir
CheckCrashFire_endLoop:
inc hl      ;siguiente enemigo
djnz CheckCrashFire_loop    ;en caso de no ser 0, continuar el bucle

ret

;change level
changeLevel:
ld a,(levelCounter+1) ;cargamos el contador de nivel
inc a       ; incrementamos el nivel
cp $1f      ; comparamos con 1f
jr c, changeLevel_end   ; si hay acarreo quiere decir que hemos llegado al final
ld a, $01   ; cargamos el valor 01

changeLevel_end:
ld (levelCounter),a ; almacenamos en el contador el nuevo valor de a
call LoadUdgsEnemies    ;cargamos los siguientes enemigos
ld a,$20    ;inicializamos los enemigos
ld (enemiesCounter+1),a   ;almacenamos el nuevo valor del contador
ld hl,enemiesConfigIni  ;cargamos la nueva configuracion de nuevo
ld de, enemiesConfig    ;cargamos en de la direccion de la configuracion
ld bc, enemiesConfigEnd-enemiesConfigIni ; numero de bytes a cargar
ldir ;copiar los bytes

ret

;checkCrash Ship

checkCrashShip:

ld de,(shipPos) ;cargamos posicion de la nave
ld hl, enemiesConfig    ;cargamos configuracion enemigos
ld h, enemiesConfigEnd-enemiesConfigIni ; numero de bytes
sra b   ; desplazamos b
checkCrashShip_loop:
ld a,(hl)   ;cargamos en a el valor de hl
inc hl      ;obtenemos el siguiente byte
bit $07,a   ;obtenemos el bit 7 de a para saber si esta activo el enemigo actual
jr z, checkCrashShip_Endloop ; si esta a 0, ir al final
and $1f ; obtenemos los datos
cp d    ; comparamos a con d
jr nz, checkCrashShip_Endloop ; si no es 0, ir al final
ld a,(hl)   ; cargamos el valor que hay en hl
and $1f     ; realizamos un and
cp e        ; comparamos con e
jr nz, checkCrashShip_Endloop   ;si no es 0, vamos al final
dec hl      ;decrementamos hl (ir al primer byte)
res $07,(hl)    ; establecemos el bit 7
ld hl, enemiesCounter   ;cargamos el contador de enemigos
dec (hl)    ; decrementamos el contador
jp PrintExplosion   ;mostramos la explosion
checkCrashShip_Endloop:
inc hl  ;incrementamos hl para ir al siguiente enemigo

djnz checkCrashShip_loop ; en caso de no haber terminado, volver al bucle

ret