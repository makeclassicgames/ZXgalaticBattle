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
