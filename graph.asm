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
; Carga los gráficos definidos por el usuario relativos a los enemigos
;
; Entrada:  A -> Nivel de 1 a 30
;
; Altera el valor de los registros A, BC, DE y HL
; -----------------------------------------------------------------------------
LoadUdgsEnemies:
ld      a, (levelCounter)       ; Carga del contador de nivel
dec     a                       ; Decrementa A para que no sume un nivel de más
ld      h, $00                  
ld      l, a                    ; Carga en HL el nivel
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