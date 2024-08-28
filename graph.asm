; rutina cambio posicion en funcion x e y (registros b y c)
at:
push bc
exx
pop bc
call $0a23; llamada a rutina para cambio de posicion
exx
ret

; rutina cambio de tinta (cambia el color de la tinta)
ink:
exx
ld b,a
ld a, (ATTR_T); variable sistema de colores
and $f8 ;cambio del color de tinta
or b ;utiliza registro b para el nuevo color
ld (ATTR_T),a ; guardar nuevo valor
exx
ret

LoadUdgsEnemies: ; rutina de carga de nivel
dec a ; decrementar a
ld h,$00; cargar 0 en h
ld l,a ; cargar a en l
add hl,hl ; aumentar hl 5 veces
add hl,hl
add hl,hl
add hl,hl
add hl,hl
ld de, udgsEnemiesLevel1 ;DE=Dirección enemigos nivel 1
add hl, de ; sumar hl a de
ld de,udgsExtension ; carga de datos en udgsExtension
ld bc,$20 ; carga $20 en bc
ldir
ret ; fin de la rutina
