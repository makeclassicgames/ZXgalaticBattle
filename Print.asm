; -----------------------------------------------------------------------------
; Borra un carácter de la pantalla
;
; Entrada:  BC -> Coordenadas Y/X del carácter
;
; Altera el valor de los resgistros AF
; -----------------------------------------------------------------------------
DeleteChar:
call    At              ; Llama a posicionar el cursor

ld      a, WHITE_GRAPH  ; Carga en A el carácter de blanco
rst     $10             ; Lo pinta y borra la nave

ret

; -----------------------------------------------------------------------------
; Pinta números en formato BCD
;
; Entrada:  HL -> Puntero al número a pintar
;
; Altera el valor de los registros AF.
; -----------------------------------------------------------------------------
PrintBCD:
ld      a, (hl)     ; Carga en A el número a pintar
and     $f0         ; Se queda con las decenas
rra
rra
rra
rra                 ; Lo pone en los bits 0 a 3
add     a, '0'      ; Le suma el carácter 0
rst     $10         ; Pinta el dígito

ld      a, (hl)     ; Carga el A el número a pintar
and     $0f         ; Se queda con las unidades
add     a, '0'      ; Le suma el carácter 0
rst     $10         ; Pinta el dígito

ret

; -----------------------------------------------------------------------------
; Pinta los enemigos
;
; Altera el valor de los registros AF, BC, D y HL.
; -----------------------------------------------------------------------------
PrintEnemies:
ld      a, (enemiesColor)           ; Carga en A la tinta
call    Ink                         ; Cambia la tinta

ld      hl, enemiesConfig           ; Carga la dirección de la configuración 
                                    ; del enemigo en HL
ld      d, ENEMIES                  ; Carga en D el número de enemigos

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
call    At                          ; Posiciona el cursor

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

; -----------------------------------------------------------------------------
; Pinta la explosión de la nave
;
; Alter los valores de los registros AF, BC, DE y HL.
; -----------------------------------------------------------------------------
PrintExplosion:
ld      a, $02
call    Ink             ; Pone la tinta en rojo

ld      bc, (shipPos)   ; Carga en BC la posición de la nave
ld      d, $04          ; Carga en D el número de UDG totales de la explosión
ld      e, $92          ; Carga en E el primer UDG de la explosión
printExplosion_loop:
call    At              ; Posiciona el cursor
ld      a, e            ; Carga en A el UDG
rst     $10             ; Lo pinta
halt
halt
halt
halt                    ; Espera 4 interrupciones
inc     e               ; Apunta E al siguiente UDG
dec     d               ; Decrementa D
jr      nz, printExplosion_loop ; Bucle hasta que D = 0

call    PlayExplosion   ; Emite el sonido de la explosión
jp      PrintShip       ; Pinta la nave y sale por allí

; -----------------------------------------------------------------------------
; Pinta el disparo en la posición actual.
;
; Altera el valor de los registros AF y BC.
; -----------------------------------------------------------------------------
PrintFire:
ld      a, $02          ; Carga en A la tinta roja
call    Ink             ; Llama al cambio de tinta

ld      bc, (firePos)   ; Carga en BC la posición actual del disparo
call    At              ; Llama a posicionar el cursor

ld      a, FIRE_GRAPH   ; Carga en A el carácter del fuego
rst     $10             ; Lo pinta

ret

; -----------------------------------------------------------------------------
; Pinta el marco de la pantalla.
;
; Altera el valor de los registros HL, B y AF.
; -----------------------------------------------------------------------------
PrintFrame:
ld      hl, frameTopGraph       ; Carga en HL la dirección de la parte superior
call    PrintString             ; Pinta la cadena

ld      hl, frameBottomGraph    ; Carga en HL la dirección de la parte inferior
call    PrintString             ; Pinta la cadena

ld      b, COR_Y - $01          ; Apunta B a la línea 1
printFrame_loop:
ld      c, COR_X - MIN_X        ; Apunta C a la columna 0
call    At                      ; Posiciona el cursor
ld      a, $99                  ; Carga en A el carácter lateral izquierdo
rst     $10                     ; Lo pinta

ld      c, COR_X - MAX_X        ; Apunta C a la columna 31
call    At                      ; Posiciona el cursor
ld      a, $9a                  ; Carga en A el carácter lateral derecho
rst     $10                     ; Lo pinta

dec     b                       ; Decrementa B
ld      a, COR_Y - MAX_Y + $01  ; Apunta A a la línea 20
sub     b                       ; Resta la siguiente línea
jr      nz, printFrame_loop     ; Si el resultado no es cero, sigue con el bucle

ret

; -----------------------------------------------------------------------------
; Pinta la dificultad seleccionada en el menú
;
; Altera el valor de los registros AF y BC.
; -----------------------------------------------------------------------------
PrintHardness:
ld      a, $02          ; Carga en A la tinta
call    Ink             ; Asigna la tinta
ld      b, $08          ; Carga en B la coordenada Y (invertida)
ld      c, $0a          ; Carga en X la coordenada X (invertida)
call    At              ; Posiciona el cursor
ld      a, (hardness)   ; Carga en A la dificultad
add     a, '0'          ; Le suma el carácter 0
rst     $10             ; Pinta la dificultad

ret

; -----------------------------------------------------------------------------
; Pinta los títulos de información de la partida.
; Altera el valor de los registros A, C y HL.
; -----------------------------------------------------------------------------
PrintInfoGame:
ld      a, $01          ; Carga 1 en A
call    OPENCHAN        ; Activa el canal 1, línea de comando
ld      hl, infoGame    ; Carga la dirección de la cadena de títulos en HL
call    PrintString     ; Pinta la cadena de títulos
ld      a, $02          ; Carga 2 en A
call    OPENCHAN        ; Activa el canal 2, pantalla superior

ret

; -----------------------------------------------------------------------------
; Pinta los valores de la información de la partida.
;
; Altera el valor de los registros AF, BC y HL.
; -----------------------------------------------------------------------------
PrintInfoValue:
ld      a, $01                  ; Carga 1 en A
call    OPENCHAN                ; Activa el canal 1, línea de comando

ld      bc, COR_LIVE            ; Carga la posición de las vidas en BC
call    At                      ; Posiciona el cursor
ld      hl, livesCounter        ; Apunta HL al contador de vidas
call    PrintBCD                ; Lo pinta

ld      bc, COR_POINT           ; Carga en BC la posición de los puntos
call    At                      ; Posiciona el cusor
ld      hl, pointsCounter + 1   ; Apunta HL a unidades de millar y centenas
call    PrintBCD                ; Lo pinta
ld      hl, pointsCounter       ; Apunta HL a decenas y unidades
call    PrintBCD                ; Lo pinta

ld      bc, COR_LEVEL           ; Carga en BC la posición de los niveles
call    At                      ; Posiciona el cursor
ld      hl, levelCounter + 1    ; Apunta HL al contador de niveles en BCD
call    PrintBCD                ; Lo pinta

ld      bc, COR_ENEMY           ; Carga en BC la posición de los enemigos
call    At                      ; Posiciona el cursor
ld      hl, enemiesCounter      ; Apunta HL al contador de enemigos
call    PrintBCD                ; Lo pinta

ld      a, $02                  ; Carga 2 en A
call    OPENCHAN                ; Activa el canal 2, pantalla superior

ret

; -----------------------------------------------------------------------------
; Pinta la nave en la posición actual.
; Altera el valor de los registros A y BC.
; -----------------------------------------------------------------------------
PrintShip:
ld      a, $07          ; Carga en A la tinta blanca
call    Ink             ; Llama al cambio de tinta

ld      bc, (shipPos)   ; Carga en BC la posición actual de la nave
call    At              ; Llama a posicionar el cursor

ld      a, SHIP_GRAPH   ; Carga en A el carácter de la nave
rst     $10             ; La pinta

ret

; -----------------------------------------------------------------------------
; Pinta cadenas terminadas en $FF.
;
; Entrada:  HL = primera posición de memoria de la cadena
;
; Altera el valor de los registros AF y HL
; -----------------------------------------------------------------------------
PrintString:
ld      a, (hl)         ; Carga en A el carácter a pintar
cp      $ff             ; Comprueba si es $FF
ret     z               ; De ser así sale
rst     $10             ; Pinta el carácter
inc     hl              ; Apunta HL al siguiente carácter
jr      PrintString     ; Bucle hasta que termine de pintar la cadena

; -----------------------------------------------------------------------------
; Pantalla de presentación, selección de controles y dificultad.
;
; Altera el valor de los registros AF, BC y HL.
; -----------------------------------------------------------------------------
PrintFirstScreen:
call    CLS                 ; Limpia la pantalla
ld      hl, title           ; Carga en HL la definición del título
call    PrintString         ; Pinta el título
ld      hl, firstScreen     ; Carga en HL la definición de la pantalla
call    PrintString         ; Pinta la pantalla
call    PrintHardness       ; Pinta la dificultad

di                          ; Desactiva las interrupciones
im      1                   ; Cambia a modo 1
ei                          ; Reactiva las interrupciones

ld      hl, FLAGS_KEY		; Carga en HL la dirección de los indicadores del teclado
set	    $03, (hl)		    ; Pone entrada en modo L
printFirstScreen_op:
bit     $05, (hl)           ; Comprueba si se ha pulsado una tecla
jr      z, printFirstScreen_op  ; Si no se ha pulsado, vuelve al bucle
res     $05, (hl)           ; Es necesario poner el bit a 0 para futuras inspecciones
ld      b, $01              ; Carga 1 en B, opción teclas
ld      c, '0' + $01        ; Carga el código ASCII del 1 en C
ld      a, (LAST_KEY)       ; Carga en A la última tecla pulsada
cp      c                   ; Comprueba si ha pulsado el 1
jr      z, printFirstScreen_end ; Si se ha pulsado el 1, sale
inc     b                   ; Incrementa B, opción Kempston
inc     c                   ; Incrementa C, tecla 2
cp      c                   ; Comprueba si ha pulsado el 2
jr      z, printFirstScreen_end ; Si se ha pulsado el 2, sale
inc     b                   ; Incrementa B, opción Sinclair 1
inc     c                   ; Incrementa C, tecla 3
cp      c                   ; Comprueba si ha pulsado el 3
jr      z, printFirstScreen_end ; Si se ha pulsado el 3, sale
inc     b                   ; Incrementa B, opción Sinclair 2
inc     c                   ; Incrementa C, tecla 4
cp      c                   ; Comprueba si ha pulsado el 4
jr      z, printFirstScreen_end ; Si se ha pulsado el 4, sale
inc     c                   ; Incrementa C, tecla 5
cp      c                   ; Comprueba si ha pulsado el 5
jr      nz, printFirstScreen_op ; Si no se ha pulsado sigue en el bucle
ld      a, (hardness)       ; Carga la dificultad en A
inc     a                   ; La incrementa
cp      $06                 ; Comprueba si hemos pasado de 5
jr      nz, printFirstScreen_opCont ; Si no hemos pasado, salta
ld      a, $01              ; Pone A a 1
printFirstScreen_opCont:
ld      (hardness), a       ; Actualiza la dificultad en memoria
call    PrintHardness       ; La pinta
jr      printFirstScreen_op ; Bucle hasta que pulse tecla del 1 al 4

printFirstScreen_end:
ld      a, b                ; Carga en A la opción seleccionada
ld      (controls), a       ; Lo carga en memoria
call    FadeScreen          ; Fundido de pantalla

di                          ; Desactiva las interrupciones
im      2                   ; Cambia a modo 1
ei                          ; Activa las interrupciones

ret


; -----------------------------------------------------------------------------
; Pantalla de fin de partida.
;
; Entrada:  A -> Tipo de fin, 0 = Game Over, !0 = Win.
;
; Altera e vakir de los registros AF y HL.
; -----------------------------------------------------------------------------
PrintEndScreen:
push    af                      ; Preserva el valo de AF
call    FadeScreen              ; Fundido de pantalla
ld      hl, title               ; Apunta HL al título
call    PrintString             ; Pinta el título
pop     af                      ; Recupera el valor de AF
or      a                       ; Evalúa si A vale 0
jr      nz, printEndScreen_Win  ; Si no vale 0, salta

printEndScreen_GameOver:
ld      hl, gameOverScreen      ; Apunta HL a la pantalla de Game Over
call    PrintString             ; La pinta
jr      printEndScreen_WaitKey  ; Salta a esperar pulsación de Enter

printEndScreen_Win:
ld      hl, winScreen           ; Apunta HL a la pantalla de Win
call    PrintString             ; La pinta

printEndScreen_WaitKey:
ld      hl, pressEnter          ; Apunta HL a la cadena 'Pulse Enter'
call    PrintString             ; La pinta
call    PrintInfoGame           ; Pinta los títulos de información de la partida
call    PrintInfoValue          ; Pinta los datos de la partida

printEndScreen_WaitKeyLoop:
ld      a, $bf                  ; Carga a semifila 1-5 en A
in      a, ($fe)                ; Lee el teclado
rra                             ; Rota A a la derecha para ver estado del uno
jr      c, printEndScreen_WaitKeyLoop   ; Si hay acarreo no se ha pulsado, bucle
call    FadeScreen              ; Fundido de pantalla

ret 