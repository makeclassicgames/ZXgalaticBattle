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

;mover disparo
moveFire:
ld hl,flags
bit $01,(hl)
jr nz,moverFire_try
bit $02,d
ret z
set $01,(hl)
ld bc,(shipPos)
inc b
jr moveFire_print
moverFire_try:
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