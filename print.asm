;Imprime una cadena por pantalla
PrintString:
ld a,(hl)
rst $10
inc hl
djnz PrintString
ret