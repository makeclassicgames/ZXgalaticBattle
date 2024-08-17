;funcion de posicionamiento (registros B (x) y C (y))
at:
push    bc      ; Preservamos el valor de BC
exx             ; Preservamos el valor de BC, DE y HL
pop     bc      ; Recuperamos el valor de BC
call	$0a23	; Llama a la rutina de la ROM
exx             ; Recuperamos el valor de BC, DE y HL

ret
;Rutina de cambio de tinta
ink:
exx                     ; Preserva el valor de BC, DE y HL
ld      b, a            ; Carga la tinta en B
ld      a, (ATTR_T)     ; Carga los atributos actuales en A
and     $f8             ; Desecha los bits de la tinta
or      b               ; Añade la tinta
ld      (ATTR_T), a     ; Carga los atributos actuales
exx                     ; Recupera el valor de BC, DE y HL

ret
LoadUdgsEnemies: ; rutina de carga de nivel
dec a
ld h,$00
ld l,a
add hl,hl
add hl,hl
add hl,hl
add hl,hl
add hl,hl
ld de, udgsEnemiesLevel1 ;DE=Dirección enemigos nivel 1
add hl, de
ld de,udgsExtension
ld bc,$20
ldir
ret
