; -----------------------------------------------------------------------------
; Posiciona el cursor en las coordenadas especificadas.
;
; Entrada:	B = Coordenada Y (24 a 3).
;		    C = Coordenada X (32 a 1).
; Altera el valor de los registros AF
; -----------------------------------------------------------------------------
At:
push    bc      ; Preservamos el valor de BC
exx             ; Preservamos el valor de BC, DE y HL
pop     bc      ; Recuperamos el valor de BC
call	$0a23	; Llama a la rutina de la ROM
exx             ; Recuperamos el valor de BC, DE y HL

ret

; -----------------------------------------------------------------------------
; Cambia los atributos de color de la pantalla.
;
; Entrada:	A = Atributos de color (FBPPPIII).
;
; Altera el valor de los registros AF, BC, DE y HL.
; -----------------------------------------------------------------------------
Cla:
ld      hl, $5800   ; Apunta HL a la dirección de inicio de los atributos
ld      (hl), a     ; Carga los atributos
ld      de, $5801   ; Apunta DE a la segunda dirección de los atributos
ld      bc, $02ff   ; Carga en BC el número de posiciones a cambiar
ldir                ; Cambia los atributos de la pantalla

ret

; -----------------------------------------------------------------------------
; Efecto de desvanecimento de la pantalla.
;
; Altera el valor de los registros AF, BC, DE y HL.
; -----------------------------------------------------------------------------
FadeScreen:
ld      b, $08      ; El bucle exterior se repite 8 veces, 1 por bit

fadeScreen_loop1:
ld      hl, $4000   ; Apunta HL al inicio del área de vídeo
ld      de, $1800   ; Carga en de la longitud del área de vídeo

fadeScreen_loop2:
ld      a, (hl)     ; Carga en A el byte apuntado por HL
or      a           ; Comprueba si tiene algún píxel activo
jr      z, fadeScreen_cont  ; Si no hay ninguno activo, salta

bit     $00, l      ; Comprueba si la dirección apuntada por HL es par/impar
jr      z, fadeScreen_right	; Si es par, salta

rla                 ; Rota A un bit a la izquierda 
jr      fadeScreen_cont

fadeScreen_right:
rra                 ; Rota A un bite a la derecha

fadeScreen_cont:
ld      (hl), a     ; Actualiza la posición de vídeo apuntada por HL
inc     hl          ; Apunta HL a la siguiente posición

dec     de
ld      a, d
or      e
jr      nz, fadeScreen_loop2    ; Bucle hasta que BC = 0

ld      a, b        ; Carga B en A
dec     a           ; Decrementa A para que quede entre 0 y 7
push    bc          ; Preserva el valor de BC
call    Cla         ; Cambia los colores de la pantalla
pop     bc          ; Recupera el valor de BC

djnz    fadeScreen_loop1    ; Bucle hasta que B = 0

ret

; -----------------------------------------------------------------------------
; Carga los gráficos definidos por el usuario relativos a los enemigos
;
; Altera el valor de los registros AF, BC, DE y HL
; -----------------------------------------------------------------------------
LoadUdgsEnemies:
ld      a, (levelCounter)       ; Carga en A el nivel
dec     a                       ; Decrementa A para que no sume un nivel de más
ld      h, $00
ld      l, a                    ; Carga el resultado en HL
add     hl, hl                  ; Multiplica por 2
add     hl, hl                  ; por 4
add     hl, hl                  ; por 8
add     hl, hl                  ; por 16
add     hl, hl                  ; por 32
ld      de, udgsEnemiesLevel1   ; Carga la dirección del enemigo 1 en DE
add     hl, de                  ; Lo suma a HL
ld      de, udgsExtension       ; Carga en DE la dirección de la extensión
ld      bc, $20                 ; Carga en BC el número de bytes a copiar, 32
ldir                            ; Copia los bytes del enemigo en los de extensión

ret

; -----------------------------------------------------------------------------
; Cambia la tinta
;
; Entrada:  A -> Color de la tinta
; Altera el valor del registro A
; -----------------------------------------------------------------------------
Ink:
exx                     ; Preserva el valor de BC, DE y HL
ld      b, a            ; Carga la tinta en B
ld      a, (ATTR_T)     ; Carga los atributos actuales en A
and     $f8             ; Desecha los bits de la tinta
or      b               ; Añade la tinta
ld      (ATTR_T), a     ; Carga los atributos actuales
exx                     ; Recupera el valor de BC, DE y HL

ret