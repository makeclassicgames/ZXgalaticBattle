;funcion de posicionamiento (registros B (x) y C (y))
at:
push bc
exx
pop bc
call $0a23 ;Rutina ROM de posicionamiento de rom
exx
ret
;Rutina de cambio de tinta
ink:
exx
ld b,a 
ld a,(ATTR_T)
and $f8
or b
ld (ATTR_T),a
exx
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
