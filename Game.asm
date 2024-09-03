; -----------------------------------------------------------------------------
; Cambia la dirección de los enemigos.
;
; Altera el valor de los registros AF, BC y HL.
; -----------------------------------------------------------------------------
ChangeEnemies:
ld      hl, flags           ; Carga la dirección de memoria de flags en HL
bit     $03, (hl)           ; Comprueba si el bit 3 (cambio dirección) está activo
ret     z                   ; Si no es así, sale                
res     $03, (hl)           ; Desactiva el bit 3 de flags

ld      b, ENEMIES          ; Carga en D el número total de enemigos
ld      hl, enemiesConfig   ; Cara en HL la dirección de la configuración 
                            ; de los enemigos
ld      a, (swEnemies)      ; Carga en A el auxiliar para cambiar la dirección
ld      c, a                ; Preserva el valor en C
changeEnemies_loop:
bit     $07, (hl)           ; Comprueba si el enemigo está activo
jr      z, changeEnemies_endLoop  ; Si no lo está, salta a final del bucle

inc     hl                  ; Apunta HL al segundo byte de la configuración
ld      a, (hl)             ; Carga el valor en HL
and     $3f                 ; Desecha la dirección
or      c                   ; Agrega la nueva dirección
ld      (hl), a             ; Actualiza la dirección en memoria

dec     hl                  ; Apunta HL al primer byte de la configuración
ld      a, c                ; Recupera la nueva dirección
add     a, $40              ; Le suma uno a la dirección ($40 = 0100 0000)
ld      c, a                ; Preserva la nueva dirección en C

changeEnemies_endLoop:
inc     hl                  ; Aputa HL al primer byte de la configuración
inc     hl                  ; del siguiente enemigo
djnz    changeEnemies_loop  ; Hasta que B sea cero (20 enemigos)

changeEnemies_end:
ld      a, c                ; Recupera la nueva dirección
ld      (swEnemies), a      ; La actualiza en memoria

ret

; -----------------------------------------------------------------------------
; Cambia de nivel.
;
; Altera el valor de los registros AF, BC, DE y HL.
; -----------------------------------------------------------------------------
ChangeLevel:
ld      a, $06                  ; Carga el color amarillo en A
ld      (enemiesColor), a       ; Actualiza el color en memoria

ld      a, (levelCounter + 1)   ; Carga en A el nivel actual en BCD
inc     a                       ; Incrementa el nivel
daa                             ; Hace el ajuste decimal
ld      b, a                    ; Carga el valor en B
ld      a, (levelCounter)       ; Carga el nivel actual en A
inc     a                       ; Carga en A el siguiente nivel

ld      hl, Song_1              ; Apunta HL a la canción 1
bit     $00, a                  ; Evalúa el bit cero del nivel saber si es par
jr      z, changeLevel_cont     ; Si es par salta
ld      hl, Song_2              ; Si es impar apunta HL a la canción 2

changeLevel_cont:
ld      (ptrSound), hl          ; Actualiza la siguiente nota
ex      af, af'                 ; Preserva el registro AF (A = siguiente nivel)
ld      a, (hl)                 ; Carga en A el byte inferior de la nota (ritmo)
ld      (music), a              ; Lo carga en los indicadores de la música
ex      af, af'                 ; Recupera el valor de AF
cp      $1f                     ; Compara si el nivel es el 31
jr      c, changeLevel_end      ; Si no es el 31, salta

ld      a, $01                  ; Si es el 31, lo pone a 1
ld      b, a                    ; Cargamos el valor en B

changeLevel_end:
ld      (levelCounter), a       ; Actualiza el nivel en memoria    
ld      a, b                    ; Carga en A el nivel en BCD
ld      (levelCounter + 1), a   ; Lo actualiza en memoria
call    LoadUdgsEnemies         ; Carga los gráficos de los enemigos

ld      a, $20                  ; Carga en A el número total de enemigos
ld      (enemiesCounter), a     ; Lo carga en memoria

ld      hl, enemiesConfigIni    ; Apunta HL a la configuración inicial
ld      de, enemiesConfig       ; Apunta HL a la configuración
ld      bc, enemiesConfigEnd - enemiesConfigIni ; Carga en BC la longitud
                                                ; de la configuración
ldir                            ; Carga la configuración inicial en la configuración

ld      hl, shipPos             ; Apunta HL a la posición de la nave
ld      (hl), SHIP_INI          ; Carga la posición inicial

ret

; -----------------------------------------------------------------------------
; Evalúa las colisiones del disparo con los enemigos.
;
; Altera el valor de lo registros AF, BC, DE y HL.
; -----------------------------------------------------------------------------
CheckCrashFire:
ld      a, (flags)              ; Carga los flags en A
and     $02                     ; Evalúa si el disparo está activo
ret     z                       ; Si no está activo, sale

ld      de, (firePos)           ; Carga en DE la posición del disparo
ld      hl, enemiesConfig       ; Apunta HL a la definición del primer enemigo
ld      b, ENEMIES              ; Carga en B el número de enemigos
checkCrashFire_loop:
ld      a, (hl)                 ; Carga en A la coordenada Y del enemigo
inc     hl                      ; Apunta HL a la coordenada X del enemigo
bit     $07, a                  ; Evalúa si el enemigo está activo
jr      z, checkCrashFire_endLoop   ; Si no está activo, salta
and     $1f                     ; Se queda con la coordenada Y de enemigo
cp      d                       ; Lo compara con la coordenada Y del disparo
jr      nz, checkCrashFire_endLoop  ; Si no son iguales salta
ld      a, (hl)                 ; Carga en A la coordenada X del enemigo
and     $1f                     ; Se que con la coordenada X
cp      e                       ; Lo compara con la coordenada X del disparo
jr      nz, checkCrashFire_endLoop  ; Si no son iguales, salta

dec     hl                      ; Apunta HL a la coordenada Y del enemigo
res     $07, (hl)               ; Desactiva el enemigo
ld      b, d                    ; Carga la coordenada Y del disparo en B
ld      c, e                    ; Carga la coordenada X del disparo en C
call    DeleteChar              ; Borra el disparo y/o el enemigo
ld      a, (enemiesCounter)     ; Carga en A el número de enemigos
dec     a                       ; Resta uno
daa                             ; Hace el ajuste decimal
ld      (enemiesCounter), a     ; Actualiza el valor en memoria
ld      a, (pointsCounter)      ; Carga en A las unidades y decenas
add     a, $05                  ; Suma 5
daa                             ; Hace el ajuste decimal
ld      (pointsCounter), a      ; Actualiza el valor en memoria
ld      a, (pointsCounter + 1)  ; Carga en A las centenas y unidades de millar
adc     a, $00                  ; Suma 1 con acarreo
daa                             ; Hace el ajuste decimal
ld      (pointsCounter + 1), a  ; Actualiza el valor en memoria
ld      hl, (extraCounter)      ; Carga en HL el contador de vida extra
ld      bc, $0005               ; Carga 5 en BC
add     hl, bc                  ; Se lo suma a HL
ld      (extraCounter), hl      ; Lo carga en memoria
ld      bc, $01f4               ; Carga 500 en BC
sbc     hl, bc                  ; Se lo resta a HL
jr      nz, checkCrashFire_cont ; Si el resultado no es 0, cero
ld      (extraCounter), hl      ; Si es 0, pone a cero el contador de vida extra
ld      a, (livesCounter)       ; Carga en A en contador de vidas
inc     a                       ; Suma una vida
daa                             ; Hace el ajuste decimal
ld      (livesCounter), a       ; Actualiza en memoria

checkCrashFire_cont:
call    PrintInfoValue          ; Pinta la información de la partida

ret                             ; Sale de la rutina

checkCrashFire_endLoop:
inc     hl                      ; Apunta HL a la coordenada Y del siguiente enemigo
djnz    checkCrashFire_loop     ; Bucle mientras B > 0

ret

; -----------------------------------------------------------------------------
; Evalúa las colisiones de los enemigos y los disparos con la nave.
;
; Altera el valor de lo registros AF, BC, DE y HL.
; -----------------------------------------------------------------------------
CheckCrashShip:
ld      de, (shipPos)       ; Carga en DE la posición de nave
ld      hl, enemiesConfig   ; Apunta HL a la configuración de los enemigos
ld      b, ENEMIES          ; Carga en B el número de enemigos
checkCrashShip_loop:
ld      a, (hl)             ; Carga en A la coordenada Y del enemigo
inc     hl                  ; Apunta HL a la coordenada X del enemigo
bit     $07, a              ; Evalúa si el enemigo está activo
jr      z, checkCrashShip_endLoop   ; Si no lo está, salta

and     $1f                 ; Se queda con la coordenada Y del enemigo
cp      d                   ; Compara con la coordenada Y de la nave
jr      nz, checkCrashShip_endLoop  ; Si no son iguales, salta

ld      a, (hl)             ; Carga en A la coordenada X del enemigo
and     $1f                 ; Se queda con la coordenada X de enemigo
cp      e                   ; Compara con la coordenada X de la nave
jr      nz, checkCrashShip_endLoop  ; Si no son iguales, salta

dec     hl                  ; Apunta HL a la coordenada Y del enemigo
res     $07, (hl)           ; Desactiva el enemigo

ld      a, (enemiesCounter) ; Carga en A el número de enemigos
dec     a                   ; Resta uno
daa                         ; Hace el ajuste decimal
ld      (enemiesCounter), a ; Actualiza el valor en memoria
ld      a, (livesCounter)   ; Carga las vidas en A
dec     a                   ; Quita una 
daa                         ; Hace el ajuste decimal
ld      (livesCounter), a   ; Actualiza el valor en memoria
call    PrintInfoValue      ; Pinta la información de la partida

jp      PrintExplosion      ; Pinta la explosión y sale

checkCrashShip_endLoop:
inc     hl                  ; Apunta HL a la coordenada Y del siguiente enemigo
djnz    checkCrashShip_loop ; En bucle hasta que B = 0

checkCrashShipFire:
; Comprueba colisiones entre disparos enemigos y nave
ld      de, (shipPos)           ; Carga en DE la posición de la nave
ld      a, (enemiesFireCount)   
ld      b, a                    ; Carga el B el número de disparos activos
ld      hl, enemiesFire         ; Apunta HL a la configuración de los disparos
checkCrashShipFire_loop:
ld      a, (hl)                 ; Carga la coordenada Y del disparo en A
inc     hl                      ; Apunta HL a la coordenada X
res     $07, a                  ; Se queda con la coordenada Y
cp      d                       ; Compara si es la misma que la de la nave
jr      nz, checkCrashShipFire_loopCont ; Si no es la misma, salta
ld      a, (hl)                 ; Carga la coordenada X del disparo en A
cp      e                       ; Compara si es la misma que la de la nave
jr      nz, checkCrashShipFire_loopCont ; Si no es la misma, salta
; Si llega aquí, la nave a colisionado con el disparo
dec     hl                      ; Apunta HL al primer byte del disparo
res     $07, (hl)               ; Desactiva el disparo
ld      a, (livesCounter)       ; Carga las vidas en A
dec     a                       ; Quita una 
daa                             ; Hace el ajuste decimal
ld      (livesCounter), a       ; Actualiza el valor en memoria
call    PrintInfoValue          ; Pinta la información de la partida
call    PrintExplosion          ; Pinta la explosión
jp      RefreshEnemiesFire      ; Actualiza los disparos enemigos y sale

checkCrashShipFire_loopCont:
inc     hl                      ; Apunta HL al siguiente disparo
djnz    checkCrashShipFire_loop ; Bucle hasta que B = 0

ret

; -----------------------------------------------------------------------------
; Habilita el disparo del enemigo.
;
; Altera el valor de los registros AF, BC, DE y HL.
; -----------------------------------------------------------------------------
EnableEnemiesFire:
ld      de, (shipPos)           ; Carga en DE la posición de la nave
ld      hl, enemiesConfig       ; Apunta HL a la configuración de los enemigos
ld      b, ENEMIES              ; Carga en B el número total de enemigos

enableEnemiesFire_loop:
ld      a, (enemiesFireCount)   ; Carga en A el número de disparos activos
push    hl                      ; Preserva HL
ld      hl, firesTop            ; Apunta HL al máximo de disparos
ld      c, (hl)                 ; Lo carga en C
pop     hl                      ; Recupera el valor de HL
cp      c                       ; Compara el máximo de disparos con los activos
ret     nc                      ; Sale si se ha alcanzado

push    bc                      ; Preserva el valor de BC
ld      a, (hl)                 ; Carga en A el primer byte de la configuración
ld      b, a                    ; Lo carga en B
inc     hl                      ; Apunta HL al segundo byte de la configuración
and     $80                     ; Evalúa si el enemigo está activo
jr      z, enableEnemiesFire_loopCont   ; Si no lo está, salta

ld      a, (hl)                 ; Carga en A el segundo byte de la configuración
and     $1f                     ; Se queda con la coordenada X
cp      e                       ; La compara con la de la nave
jr      nz, enableEnemiesFire_loopCont  ; Si no son la misma, salta

; Activa el disparo
; La configuración del disparo es la del enemigo
ld      c, a                    ; Carga en C la coordenada X del enemigo
push    hl                      ; Preserva HL
push    bc                      ; Preserva BC, configuración del disparo
ld      hl, enemiesFire         ; Apunta HL a los disparos de los enemigos
ld      a, (enemiesFireCount)   ; Carga en A el contador de disparos
add     a, a                    ; Lo multiplica por dos, dos bytes por disparo
ld      b, $00
ld      c, a                    ; Carga el desplazamiento en BC
add     hl, bc                  ; Apunta HL al disparo que hay que activar
pop     bc                      ; Recupera BC, configuración del disparo
ld      (hl), b                 ; Carga en memoria el primer byte de la configuración
inc     hl                      ; Apunta HL al segundo byte de la configuración
ld      (hl), c                 ; Lo carga en memoria
ld      hl, enemiesFireCount    ; Apunta HL al contador de disparos enemigos
inc     (hl)                    ; Lo incrementa en memoria
pop     hl                      ; Recupera HL, segundo byte configuración enemigo

enableEnemiesFire_loopCont:
pop     bc                      ; Recupera el valor de BC
inc     hl                      ; Apunta HL al primer byte de configuración
                                ; del enemigo siguiente
djnz    enableEnemiesFire_loop  ; Hasta que se recorra todos los enemigos, B = 0

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

ld      a, (enemiesColor)   ; Carga el color de los enemigos en A
inc     a                   ; Lo incrementa
cp      $08                 ; Comprueba si ha llegado a 8
jr      c, moveEnemies_cont ; Si no ha llegado, salta
ld      a, $01              ; Pone el color en azul

moveEnemies_cont:
ld      (enemiesColor), a   ; Actualiza el color en memoria
ld      d, ENEMIES          ; Carga en D el número total de enemigos
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
and     $1f                 ; Se queda con la coordenada X
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
and     $1f                 ; Se queda con la coordenda Y
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
push    hl                  ; Preserva el valor de HL
ld      hl, enemiesTopB     ; Apunta HL al tope por abajo
sub     (hl)                ; Lo resta               
pop     hl                  ; Recupera el valor de HL
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
call    EnableEnemiesFire   ; Habilita los disparos de los enemigos

ret

; -----------------------------------------------------------------------------
; Mueve el disparo del enemigo.
;
; Altera el valor de los registros AF, BC, DE y HL.
; -----------------------------------------------------------------------------
MoveEnemiesFire:
ld      a, $03          ; Carga la tinta 3 en A
call    Ink             ; Cambia la tinta
ld      hl, flags       ; Apunta HL a los flags
bit     $04, (hl)       ; Comprueba si está activo el flag mover disparo enemigo
ret     z               ; Si no lo está, sale
res     $04, (hl)       ; Desactiva el flag mover disparo enemigo

ld      d, FIRES        ; Carga en D en número máximo de disparos
ld      hl, enemiesFire ; Apunta HL a los disparos enemigos
moveEnemiesFire_loop:
ld      b, (hl)         ; Carga en B la coordenada Y del disparo
inc     hl              ; Apunta HL a la coordenada X
ld      c, (hl)         ; La carga en C
dec     hl              ; Apunta HL a la coordenada Y

bit     $07, b          ; Evalúa si el disparo está activo
jr      z, moveEnemiesFire_loopCont ; Salta si no lo está
res     $07, b          ; Se queda con la coordenada Y
call    DeleteChar      ; Borra el disparo de su posición actual
ld      a, ENEMY_TOP_B + $01    ; Carga en A el tope
cp      b               ; Lo compara con la coordenada Y
jr      z, moveEnemiesFire_loopCont ; Si es la misma, salta
dec     b               ; Apunta B a la línea siguiente
call    At              ; Posiciona el cursor
ld      a, ENEMY_GRA_F  ; Carga en A el gráfico del disparo
rst     $10             ; Lo pinta
set     $07, b          ; Deja el disparo activo

moveEnemiesFire_loopCont:
ld      (hl), b         ; Actualiza la coordenada Y del disparo
inc     hl
inc     hl              ; Apunta HL al primer byte de la configuración
                        ; del siguiente enemigo

dec     d               ; Decremeta D
jr      nz, moveEnemiesFire_loop    ; Bucle hasta que D = 0

call    PlayEnemiesMove ; Emite el sonido de movimiento de enemigos
jp      RefreshEnemiesFire  ; Actualiza los disparos enemigos y sale

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
push    hl                  ; Preserva el valor de HL
call    PlayFire            ; Emite el sonido del disparo
pop     hl                  ; Recupera el valor de HL
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
; Altera el valor de los registros AF, BC y HL.
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
ld      (shipPos), bc       ; Actualiza la posición de la nave

moveShip_print:
call    PrintShip           ; Pinta la nave

ret

; -----------------------------------------------------------------------------
; Hace sonar las canciones.
;
; Altera el valor de los registros AF, BC, DE y HL.
; -----------------------------------------------------------------------------
Play:
ld      hl, (ptrSound)      ; Carga en HL la dirección de la nota actual
ld      e, (hl)             ; Carga en E el byte inferior de la frecuencia
inc     hl                  ; Apunta HL al byte superior
ld      d, (hl)             ; Lo carga en D
ld      a, d                ; Lo carga en A
or      e                   ; Comprueba si es el final de la canción
jr      z, play_reset       ; Salta si es el final
cp      $ff                 ; Comprueba si escambio de ritmo
jr      nz, play_cont       ; Si no cambiar el ritmo salta
ld      a, e                ; Carga el nuevo ritmo en A
ld      (music), a          ; Carga el nuevo ritmo en los indicadores de la música
inc     hl                  ; Apunta HL a la siguiente nota
ld      (ptrSound), hl      ; Actualiza el puntero
ret

play_reset:
ld      hl, Song_1          ; Apunta HL a la primera canción
ld      (ptrSound), hl      ; Actualiza el puntero
ret

play_cont:
inc     hl                  ; Apunta HL al byte inferior de la nota
ld      c, (hl)             ; Lo carga en C
inc     hl                  ; Apunta HL al byte superior de la nota
ld      b, (hl)             ; Lo carga en B
inc     hl                  ; Apunta HL a frecuencia de la siguiente nota
ld      (ptrSound), hl      ; Actualiza el puntero
ld      h, b                
ld      l, c                ; Carga la nota en HL

; -----------------------------------------------------------------------------
; Hace sonar una nota.
;
; Entrada:  HL -> Nota
;           DE -> Frecuencia
; -----------------------------------------------------------------------------
Play_beep:
push    af
push    bc
push    de
push    hl      ; Preserva el valor de los registros
call    BEEP    ; Llama a la rutina de la ROM
pop     hl
pop     de
pop     bc
pop     af      ; Recupera el valor de los registros

ret

; -----------------------------------------------------------------------------
; Emite el sonido del movimiento de los enemigos
;
; Altera el valor de los registros HL y DE
; -----------------------------------------------------------------------------
PlayEnemiesMove:
ld      hl, $0a     ; Carga la nota en HL
ld      de, $00     ; Carga la frecuencia en DE
call    Play_beep   ; Emite la nota

ld      hl, $14     ; Carga la nota en HL
ld      de, $20     ; Carga la frecuencia en DE
call    Play_beep   ; Emite la nota

ld      hl, $0a     ; Carga la nota en HL
ld      de, $10     ; Carga la frecuencia en DE
call    Play_beep   ; Emite la nota

ld      hl, $30     ; Carga la nota en HL
ld      de, $1e     ; Carga la frecuencia en DE
jr      Play_beep   ; Emite la nota y sale

; -----------------------------------------------------------------------------
; Emite el sonido de la explosión de la nave
;
; Altera el valor de los registros HL y DE
; -----------------------------------------------------------------------------
PlayExplosion:
ld      hl, $27a0       ; Carga la nota en HL
ld      de, $2b / $20   ; Carga la frecuencia en DE
call    Play_beep       ; Emite el sonido

ld      hl, $13f4       ; Carga la nota en HL
ld      de, $37 / $20   ; Carga la frecuencia en DE
call    Play_beep       ; Emite el sonido

ld      hl, $14b9       ; Carga la nota en HL
ld      de, $52 / $20   ; Carga la frecuencia en DE
call    Play_beep       ; Emite el sonido

ld      hl, $1a2c       ; Carga la nota en HL
ld      de, $41 / $20   ; Carga la frecuencia en DE
jr      Play_beep       ; Emite el sonido y sale

; -----------------------------------------------------------------------------
; Emite el sonido del disparo de la nave
;
; Altera el valor de los registros HL y DE
; -----------------------------------------------------------------------------
PlayFire:
ld      hl, $64     ; Carga la nota en HL
ld      de, $01     ; Carga la frecuencia en DE
jr      Play_beep   ; Emite el sonido y sale

; -----------------------------------------------------------------------------
; Actualiza la configuración de los disparos enemigos
;
; Altera el vaor de los registros AD, BC, HL e IX.
; -----------------------------------------------------------------------------
RefreshEnemiesFire:
ld      b, FIRES                    ; Carga en B el número máximo de disparos
xor     a                           ; Pone A a 0
refreshEnemiesFire_loopExt:
push    bc                          ; Preserva BC
ld      ix, enemiesFire             ; Apunta IX a la configuración de los disparos
ld      b, FIRES                    ; Carga en B el número máximo de disparos
refreshEnemiesFire_loopInt:
bit     $07, (ix+$00)               ; Evalúa si el disparo está activo
jr      nz, refreshEnemiesFire_loopIntCont  ; Si lo está, salta
ld      c, (ix+$02)                 ; Carga el byte 1 del siguiente disparo en C
ld      (ix+$00), c                 ; Lo carga en el byte 1 del disparo actual
ld      c, (ix+$03)                 ; Carga el byte 2 del siguiente disparo en C
ld      (ix+$01), c                 ; Lo carga en el byte 2 del disparo actual               
ld      (ix+$02), a                 ; Pone a cero el byte 1 del siguiente disparo
refreshEnemiesFire_loopIntCont:
inc     ix
inc     ix                          ; Apunta IX al byte 1 del siguiente disparo
djnz    refreshEnemiesFire_loopInt  ; Bucle hasta que B = 0

pop     bc                          ; Recupera BC para bucle exterior
djnz    refreshEnemiesFire_loopExt  ; Bucle hasta que B = 0

; Actualiza el número de disparos activos
ld      b, FIRES                    ; Carga en B el número máximo de disparos
ld      hl, enemiesFire             ; Apunta HL a la configuración de los disparos
refreshEnemiesFire_loopCount:
bit     $07, (hl)                   ; Evalúa si el disparo está activo
jr      z, refreshEnemiesFire_loopCountCont   ; Si no lo está, salta
inc     a                           ; Incrementa A = contador de disparos
refreshEnemiesFire_loopCountCont:
inc     hl
inc     hl                          ; Apunta HL al byte 1 del siguiente disparo
djnz    refreshEnemiesFire_loopCount    ; Bucle hasta que B = 0

refreshEnemiesFire_end:
ld      (enemiesFireCount), a       ; Actualiza el contador de disparos en memoria

ret

; -----------------------------------------------------------------------------
; Inicializa la configuración de los disparos enemigos
;
; Altera el valor de los registros BC, DE y HL.
; -----------------------------------------------------------------------------
ResetEnemiesFire:
ld      hl, enemiesFire         ; Apunta HL a la configuración de los disparos
ld      de, enemiesFire + $01   ; Apunta DE al byte siguiente
ld      bc, FIRES * $02         ; Carga en BC en número de bytes a limpiar
ld      (hl), $00               ; Limpia el primer byte
ldir                            ; Limpia el resto

ret

; -----------------------------------------------------------------------------
; Asigna la dificultad
;
; Altera el valor de los registros AF y HL
; -----------------------------------------------------------------------------
SetHardness:
ld      hl, enemiesTopB         ; Apunta HL a tope por abajo de los enemigos
ld      (hl), ENEMY_TOP_B       ; Lo actualiza con el tope por defecto
ld      a, (hardness)           ; Carga la dificultad en A
cp      $03                     ; La compara con 3
jr      nc, setHardness_Fire    ; Si no hay acarre A => 3, salta
inc     (hl)                    ; Sube una línea el tope por abajo de los enemigos
setHardness_Fire:
ld      hl, firesTop            ; Apunta HL al máximo de disparos
ld      (hl), $01               ; Lo pone a 1           
cp      $01                     ; Comprueba si la dificultad es 1
ret     z                       ; Sale si es 1
cp      $03                     ; Comprueba si la dificultad es 3
ret     z                       ; Sale si es 3
ld      (hl), FIRES             ; Carga los disparos máximos por defecto

ret

; -----------------------------------------------------------------------------
; Espera veinticinco interrupciones
; 
; Altera el valor de los registros B y F.
; -----------------------------------------------------------------------------
Sleep:
ld      b, $19      ; Carga veinticinco en B
sleep_Loop:
halt                ; Espera a una interrupción
djnz    sleep_Loop  ; Hasta que B valga 0

ret