;rutina movimiento nave
moveShip:
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