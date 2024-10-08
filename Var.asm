; -----------------------------------------------------------------------------
; Pantallas de inicio y fin de partida.
; -----------------------------------------------------------------------------
title:
db  $10, $02, $16, $00, $08, "BATALLA ESPACIAL", $0d, $0d, $ff

firstScreen:
db  $10, $06, "Las naves alienigenas atacan la", $0d
db  "Tierra, el futuro depende de ti.", $0d, $d
db  "Destruye todos los enemigos que", $0d
db  "puedas, y protege el planeta.", $0d, $0d
db  $10, $03, "Z - Izquierda", $16, $08, $15,"X - Derecha"
db  $0d, $0d, "V - Disparo", $16, $0a, $15, "M - Sonido", $0d, $0d
db  $10, $04, "1 - Teclado       3 - Sinclair 1", $0d, $0d
db  "2 - Kempston      4 - Sinclair 2", $0d, $0d
db  $10, $07, $16, $10, $07, "5 - Dificultad ", $0d, $0d
db  $10, $05, "Apunta, dispara, esquiva a las", $0d 
db "naves enemigas, vence y libera", $0d
db "al planeta de la amenza." 
db  $ff

gameOverScreen:
db  $10, $06, "Has perdido todas tus naves, no", $0d
db  "has podido salvar la Tierra.", $0d, $0d
db  "El planeta ha sido invadido por", $0d
db  "los aliengenas.", $0d, $0d
db  "Puedes volver a intentarlo, de", $0d
db  "ti depende salvar la Tierra.", $ff

winScreen:
db  $10, $06, "Enhorabuena, has destruido a los"
db  "alienigenas, salvaste la Tierra.", $0d, $0d
db  "Los habitantes del planeta te", $0d
db  "estaran eternamente agradecidos.", $ff

pressEnter:
db  $10, $04, $16, $10, $03, "Pulsa Enter para continuar", $ff

; -----------------------------------------------------------------------------
; Título de información de la partida
; -----------------------------------------------------------------------------
infoGame:
db  $10, $03, $16, $00, $00
db 'Vidas   Puntos   Nivel  Enemigos', $ff

; -----------------------------------------------------------------------------
; Información de la partida
; -----------------------------------------------------------------------------
controls:
db  $00
enemiesCounter:
db  $20
; Byte 1: cotrolador de nivel, Byte 2: para pintar el número de nivel
levelCounter:
db  $01, $01
livesCounter:
db  $05
pointsCounter:
dw  $0000
extraCounter:
dw  $0000
; -----------------------------------------------------------------------------
; Valores auxiliares
; -----------------------------------------------------------------------------
swEnemies:
db  $00
enemiesColor:
db  $06
enemiesTopB:
db  ENEMY_TOP_B
firesTop:
db  FIRES
hardness:
db  $03

; -----------------------------------------------------------------------------
; Declaraciones de los gráficos de los distintos personajes
; y la configuración de coordenadas (Y, X)
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Nave
; -----------------------------------------------------------------------------
shipPos:
dw  $0511
; -----------------------------------------------------------------------------
; Disparo
; -----------------------------------------------------------------------------
firePos:
dw  $0000

; -----------------------------------------------------------------------------
; Marco de la pantalla
; -----------------------------------------------------------------------------
frameTopGraph:
db $16, $00, $00, $10, $01
db $96, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $98, $ff
frameBottomGraph:
db $16, $14, $00
db $9b, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9d, $ff

; -----------------------------------------------------------------------------
; Gráficos de los enemigos
;
; 00 Up-Left
; 01 Up-Rigth
; 10 Down-Left
; 11 Down-Right
; -----------------------------------------------------------------------------
enemiesGraph:		
db $9f, $a0, $a1, $a2

; -----------------------------------------------------------------------------
; Configuración de los enemigos
;
; 2 bytes por enemigo.
; -----------------------------------------------------------------------------
; Byte 1                        | Byte 2
; -----------------------------------------------------------------------------
; Bit 0-4:  Posición Y          | Bit 0-4:  Posición X
; Bit 5:    Libre               | Bit 5:    Libre
; Bit 6:    Libre               | Bit 6:    Dirección X 0 = Left 1 = Right
; Bit 7:	Activo 1/0          | Bit 7:    Dirección Y 0 = Up   1 = Down
; -----------------------------------------------------------------------------
enemiesConfig:
db $96, $dd, $96, $d7, $96, $d1, $96, $cb, $96, $c5
db $93, $9d, $93, $97, $93, $91, $93, $8b, $93, $85
db $90, $dd, $90, $d7, $90, $d1, $90, $cb, $90, $c5
db $8d, $9d, $8d, $97, $8d, $91, $8d, $8b, $8d, $85
enemiesConfigIni:
db $96, $dd, $96, $d7, $96, $d1, $96, $cb, $96, $c5
db $93, $9d, $93, $97, $93, $91, $93, $8b, $93, $85
db $90, $dd, $90, $d7, $90, $d1, $90, $cb, $90, $c5
db $8d, $9d, $8d, $97, $8d, $91, $8d, $8b, $8d, $85
enemiesConfigEnd:

; -----------------------------------------------------------------------------
; Configuración de los disparos de los enemigos
;
; 2 bytes por disparo.
; -----------------------------------------------------------------------------
; Byte 1                        | Byte 2
; -----------------------------------------------------------------------------
; Bit 0-4:  Posición Y          | Bit 0-4:  Posición X
; Bit 5:    Libre               | Bit 5:    Libre
; Bit 6:    Libre               | Bit 6:    Libre
; Bit 7:	Activo 1/0          | Bit 7:    Libre
; -----------------------------------------------------------------------------
enemiesFire:
defs FIRES * $02
enemiesFireCount:
db $00

; -----------------------------------------------------------------------------
; Declaración de los gráficos generales
; -----------------------------------------------------------------------------
udgsCommon:
db $24, $42, $99, $bd, $ff, $18, $24, $5a	; $90 Nave
db $00, $18, $24, $5a, $5a, $24, $18, $00	; $91 Disparo
db $00, $00, $00, $00, $24, $5a, $24, $18	; $92 Explosión 1
db $00, $00, $00, $14, $2a, $34, $24, $18	; $93 Explosión 2
db $00, $00, $0c, $12, $2a, $56, $64, $18	; $94 Explosión 3
db $20, $51, $92, $d5, $a9, $72, $2c, $18	; $95 Explosión 4
db $3f, $6a, $ff, $b8, $f3, $a7, $ef, $ae	; $96 Esquina superior izquierda
db $ff, $aa, $ff, $00, $ff, $ff, $00, $00	; $97 Horizontal superior
db $fc, $ae, $fb, $1f, $cd, $e7, $f5, $77	; $98 Esquina superior derecha
db $ec, $ac, $ec, $ac, $ec, $ac, $ec, $ac	; $99 Lateral izquierda
db $35, $37, $35, $37, $35, $37, $35, $37	; $9a Lateral derecha
db $ee, $af, $e7, $b3, $f8, $df, $75, $3f	; $9b Esquina inferior izquierda
db $00, $00, $ff, $ff, $00, $ff, $55, $ff	; $9c Horizontal inferior
db $75, $f7, $e5, $cf, $1d, $ff, $56, $fc	; $9d Esquina inferior derecha
db $00, $3c, $2c, $2c, $2c, $2c, $18, $00	; $9e Disparo enemigo

udgsExtension:
db $00, $00, $00, $00, $00, $00, $00, $00	; $9f Left/Up
db $00, $00, $00, $00, $00, $00, $00, $00	; $a0 Rigth/Up
db $00, $00, $00, $00, $00, $00, $00, $00	; $a1 Left/Down
db $00, $00, $00, $00, $00, $00, $00, $00	; $a2 Rigth/Down

udgsEnemiesLevel1:
db $8c, $42, $2d, $1d, $b4, $be, $46, $30	; $9f Left/Up
db $31, $42, $b4, $b8, $2d, $7d, $62, $0c	; $a0 Rigth/Up
db $30, $46, $be, $b4, $1d, $2d, $42, $8c	; $a1 Left/Down
db $0c, $62, $7d, $2d, $b8, $b4, $42, $31	; $a2 Rigth/Down

udgsEnemiesLevel2:
db $c0, $fb, $69, $5d, $7b, $14, $4a, $79	; $9f Left/Up
db $03, $df, $96, $ba, $de, $28, $52, $9e	; $a0 Rigth/Up
db $79, $4a, $14, $7b, $5d, $69, $fb, $c0	; $a1 Left/Down
db $9e, $52, $28, $de, $ba, $96, $df, $03	; $a2 Rigth/Down

udgsEnemiesLevel3:
db $fc, $84, $b4, $af, $99, $f7, $14, $1c	; $9f Left/Up
db $3f, $21, $2d, $f5, $99, $ef, $28, $38	; $a0 Rigth/Up
db $1c, $14, $f7, $99, $af, $b4, $84, $fc	; $a1 Left/Down
db $38, $28, $ef, $99, $f5, $2d, $21, $3f	; $a2 Rigth/Down

udgsEnemiesLevel4:
db $f2, $95, $98, $fe, $39, $55, $92, $4d	; $9f Left/Up
db $4f, $a9, $19, $7f, $9c, $aa, $49, $b2	; $a0 Rigth/Up
db $4d, $92, $55, $39, $fe, $98, $95, $f2	; $a1 Left/Down
db $b2, $49, $aa, $9c, $7f, $19, $a9, $4f	; $a2 Rigth/Down

udgsEnemiesLevel5:
db $76, $99, $a4, $d4, $47, $bd, $8a, $4c	; $9f Left/Up
db $6e, $99, $25, $2b, $e2, $bd, $51, $32	; $a0 Rigth/Up
db $4c, $8a, $bd, $47, $d4, $a4, $99, $76	; $a1 Left/Down
db $32, $51, $bd, $e2, $2b, $25, $99, $6e	; $a2 Rigth/Down

udgsEnemiesLevel6:
db $98, $66, $59, $aa, $b6, $49, $5a, $24	; $9f Left/Up
db $19, $66, $9a, $55, $6d, $92, $5a, $24	; $a0 Rigth/Up
db $24, $5a, $49, $b6, $aa, $59, $66, $98	; $a1 Left/Down
db $24, $5a, $92, $6d, $55, $9a, $66, $19	; $a2 Rigth/Down

udgsEnemiesLevel7:
db $04, $72, $5d, $74, $2e, $be, $4c, $20	; $9f Left/Up
db $20, $4e, $ba, $2e, $74, $7d, $32, $04	; $a0 Rigth/Up
db $20, $4c, $be, $2e, $74, $5d, $72, $04	; $a1 Left/Down
db $04, $32, $7d, $74, $2e, $ba, $4e, $20	; $a2 Rigth/Down

udgsEnemiesLevel8:
db $00, $7c, $5a, $68, $7c, $4f, $26, $04	; $9f Left/Up
db $00, $3e, $5a, $16, $3e, $f2, $64, $20	; $a0 Rigth/Up
db $04, $26, $4f, $7c, $68, $5a, $7c, $00	; $a1 Left/Down
db $20, $64, $f2, $3e, $16, $5a, $3e, $00	; $a2 Rigth/Down

udgsEnemiesLevel9:
db $e0, $d8, $b6, $6e, $5b, $36, $3c, $08	; $9f Left/Up
db $07, $1b, $6d, $76, $da, $6c, $3c, $10	; $a0 Rigth/Up
db $08, $3c, $36, $5b, $6e, $b6, $d8, $e0	; $a1 Left/Down
db $10, $3c, $6c, $da, $76, $6d, $1b, $07	; $a2 Rigth/Down

udgsEnemiesLevel10:
db $e0, $ce, $bf, $3c, $73, $75, $6a, $2c	; $9f Left/Up
db $07, $73, $fd, $3c, $ce, $ae, $56, $34	; $a0 Rigth/Up
db $2c, $6a, $75, $73, $3c, $bf, $ce, $e0	; $a1 Left/Down
db $34, $56, $ae, $ce, $3c, $fd, $73, $07	; $a2 Rigth/Down

udgsEnemiesLevel11:
db $e0, $de, $bf, $7c, $7b, $75, $6a, $2c	; $9f Left/Up
db $07, $7b, $fd, $3e, $de, $ae, $56, $34	; $a0 Rigth/Up
db $2c, $6a, $75, $7b, $7c, $bf, $de, $e0	; $a1 Left/Down
db $34, $56, $ae, $de, $3e, $fd, $7b, $07	; $a2 Rigth/Down

udgsEnemiesLevel12:
db $e0, $fe, $f7, $6c, $5f, $7e, $6c, $28	; $9f Left/Up
db $07, $7f, $ef, $36, $fa, $7e, $36, $14	; $a0 Rigth/Up
db $28, $6c, $7e, $5f, $6c, $f7, $fe, $e0	; $a1 Left/Down
db $14, $36, $7e, $fa, $36, $ef, $7f, $07	; $a2 Rigth/Down

udgsEnemiesLevel13:
db $07, $6c, $7e, $34, $6f, $fb, $ae, $8c	; $9f Left/Up
db $e0, $36, $7e, $2c, $f6, $df, $75, $31	; $a0 Rigth/Up
db $8c, $ae, $fb, $6f, $34, $7e, $6c, $07	; $a1 Left/Down
db $31, $75, $df, $f6, $2c, $7e, $36, $e0	; $a2 Rigth/Down

udgsEnemiesLevel14:
db $21, $1a, $96, $75, $4c, $3c, $62, $90	; $9f Left/Up
db $84, $58, $69, $ae, $32, $3c, $46, $09	; $a0 Rigth/Up
db $90, $62, $3c, $4c, $75, $96, $1a, $21	; $a1 Left/Down
db $09, $46, $3c, $32, $ae, $69, $58, $84	; $a2 Rigth/Down

udgsEnemiesLevel15:
db $04, $02, $0d, $14, $28, $b0, $40, $20	; $9f Left/Up
db $20, $40, $b0, $28, $14, $0d, $02, $04	; $a0 Rigth/Up
db $20, $40, $b0, $28, $14, $0d, $02, $04	; $a1 Left/Down
db $04, $02, $0d, $14, $28, $b0, $40, $20	; $a2 Rigth/Down

udgsEnemiesLevel16:
db $30, $48, $be, $b9, $7c, $2e, $27, $13	; $9f Left/Up
db $0c, $12, $7d, $9d, $3e, $74, $e4, $c8	; $a0 Rigth/Up
db $13, $27, $2e, $7c, $b9, $be, $48, $30	; $a1 Left/Down
db $c8, $e4, $74, $3e, $9d, $7d, $12, $0c	; $a2 Rigth/Down

udgsEnemiesLevel17:
db $c0, $df, $36, $7c, $58, $77, $66, $44	; $9f Left/Up
db $03, $fb, $6c, $3e, $1a, $ee, $66, $22	; $a0 Rigth/Up
db $44, $66, $77, $58, $7c, $36, $df, $c0	; $a1 Left/Down
db $22, $66, $ee, $1a, $3e, $6c, $fb, $03	; $a2 Rigth/Down

udgsEnemiesLevel18:
db $02, $71, $69, $57, $2f, $1e, $9e, $78	; $9f Left/Up
db $40, $8e, $96, $ea, $f4, $78, $79, $1e	; $a0 Rigth/Up
db $78, $9e, $1e, $2f, $57, $69, $71, $02	; $a1 Left/Down
db $1e, $79, $78, $f4, $ea, $96, $8e, $40	; $a2 Rigth/Down

udgsEnemiesLevel19:
db $20, $7f, $e6, $4e, $5e, $79, $78, $44	; $9f Left/Up
db $04, $fe, $67, $72, $7a, $9e, $1e, $22	; $a0 Rigth/Up
db $44, $78, $79, $5e, $4e, $e6, $7f, $20	; $a1 Left/Down
db $22, $1e, $9e, $7a, $72, $67, $fe, $04	; $a2 Rigth/Down

udgsEnemiesLevel20:
db $36, $2f, $db, $be, $7c, $db, $f6, $64	; $9f Left/Up
db $6c, $f4, $db, $7d, $3e, $db, $6f, $26	; $a0 Rigth/Up
db $64, $f6, $db, $7c, $be, $db, $2f, $36	; $a1 Left/Down
db $26, $6f, $db, $3e, $7d, $db, $f4, $6c	; $a2 Rigth/Down

udgsEnemiesLevel21:
db $00, $70, $6e, $54, $2b, $34, $28, $08	; $9f Left/Up
db $00, $0e, $76, $2a, $d4, $2c, $14, $10	; $a0 Rigth/Up
db $08, $28, $34, $2b, $54, $6e, $70, $00	; $a1 Left/Down
db $10, $14, $2c, $d4, $2a, $76, $0e, $00	; $a2 Rigth/Down

udgsEnemiesLevel22:
db $00, $78, $6e, $56, $6d, $3b, $34, $0c	; $9f Left/Up
db $00, $1e, $76, $6a, $b6, $dc, $2c, $30	; $a0 Rigth/Up
db $0c, $34, $3b, $6d, $56, $6e, $78, $00	; $a1 Left/Down
db $30, $2c, $dc, $b6, $6a, $76, $1e, $00	; $a2 Rigth/Down

udgsEnemiesLevel23:
db $0c, $02, $3d, $35, $ac, $b8, $40, $30	; $9f Left/Up
db $30, $40, $bc, $ac, $35, $1d, $02, $0c	; $a0 Rigth/Up
db $30, $40, $b8, $ac, $35, $3d, $02, $0c	; $a1 Left/Down
db $0c, $02, $1d, $35, $ac, $bc, $40, $30	; $a2 Rigth/Down

udgsEnemiesLevel24:
db $00, $77, $6e, $56, $2a, $74, $7b, $42	; $9f Left/Up
db $00, $ee, $76, $6a, $54, $2e, $de, $42	; $a0 Rigth/Up
db $42, $7b, $74, $2a, $56, $6e, $77, $00	; $a1 Left/Down
db $42, $de, $2e, $54, $6a, $76, $ee, $00	; $a2 Rigth/Down

udgsEnemiesLevel25:
db $c0, $ff, $76, $6c, $5f, $7e, $6c, $48	; $9f Left/Up
db $03, $ff, $6e, $36, $fa, $7e, $36, $12	; $a0 Rigth/Up
db $48, $6c, $7e, $5f, $6c, $76, $ff, $c0	; $a1 Left/Down
db $12, $36, $7e, $fa, $36, $6e, $ff, $03	; $a2 Rigth/Down

udgsEnemiesLevel26:
db $3c, $7e, $f7, $e8, $da, $e1, $68, $24	; $9f Left/Up
db $3c, $7e, $ef, $17, $5b, $87, $16, $24	; $a0 Rigth/Up
db $24, $68, $e1, $da, $e8, $f7, $7e, $3c	; $a1 Left/Down
db $24, $16, $87, $5b, $17, $ef, $7e, $3c	; $a2 Rigth/Down

udgsEnemiesLevel27:
db $04, $02, $39, $2d, $3f, $9e, $4c, $38	; $9f Left/Up
db $20, $40, $9c, $b4, $fc, $79, $32, $1c	; $a0 Rigth/Up
db $38, $4c, $9e, $3f, $2d, $39, $02, $04	; $a1 Left/Down
db $1c, $32, $79, $fc, $b4, $9c, $40, $20	; $a2 Rigth/Down

udgsEnemiesLevel28:
db $00, $37, $69, $5c, $34, $5f, $46, $64	; $9f Left/Up
db $00, $ec, $96, $3a, $2c, $fa, $62, $26	; $a0 Rigth/Up
db $64, $46, $5f, $34, $5c, $69, $37, $00	; $a1 Left/Down
db $26, $62, $fa, $2c, $3a, $96, $ec, $00	; $a2 Rigth/Down

udgsEnemiesLevel29:
db $00, $37, $6d, $5e, $34, $7f, $56, $64	; $9f Left/Up
db $00, $ec, $b6, $7a, $2c, $fe, $6a, $26	; $a0 Rigth/Up
db $64, $56, $7f, $34, $5e, $6d, $37, $00	; $a1 Left/Down
db $26, $6a, $fe, $2c, $7a, $b6, $ec, $00	; $a2 Rigth/Down

udgsEnemiesLevel30:
db $e0, $ff, $ed, $5b, $7e, $6e, $5f, $72	; $9f Left/Up
db $07, $ff, $b7, $da, $7e, $76, $fa, $4e	; $a0 Rigth/Up
db $72, $5f, $6e, $7e, $5b, $ed, $ff, $e0	; $a1 Left/Down
db $4e, $fa, $76, $7e, $da, $b7, $ff, $07	; $a2 Rigth/Down

; -----------------------------------------------------------------------------
; Datos necesarios para la música.
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Siguiente nota
; -----------------------------------------------------------------------------
ptrSound:
dw  $0000

; -----------------------------------------------------------------------------
; Canciones
; -----------------------------------------------------------------------------
Song_1:
dw  $ff0c
dw  G_2_f, G_2, G_2_f, G_2, G_2_f, G_2, Ds_2_f, Ds_2, As_2_f, As_2, G_2_f, G_2, Ds_2_f, Ds_2, As_2_f, As_2, G_2_f, G_2
dw  G_2_f, G_2, G_2_f, G_2, G_2_f, G_2, Ds_2_f, Ds_2, As_2_f, As_2, G_2_f, G_2, Ds_2_f, Ds_2, As_2_f, As_2, G_2_f, G_2
dw  D_3_f, D_3, D_3_f, D_3, D_3_f, D_3, Ds_3_f, Ds_3, As_2_f, As_2, Fs_2_f, Fs_2, Ds_2_f, Ds_2, As_2_f, As_2, G_2_f, G_2

dw  G_3_f, G_3, G_2_f, G_2, G_2_f, G_2, G_3_f, G_3, Fs_3_f, Fs_3, F_3_f, F_3, E_3_f, E_3, Ds_3_f, Ds_3, E_3_f, E_3
dw  Gs_2_f, Gs_2, Cs_3_f, Cs_3, C_3_f, C_3, B_2_f, B_2, As_2_f, As_2, A_2_f, A_2, As_2_f, As_2
dw  Ds_2_f, Ds_2, Fs_2_f, Fs_2, Ds_2_f, Ds_2, Fs_2_f, Fs_2, As_2_f, As_2, G_2_f, G_2, As_2_f, As_2, D_3_f, D_3

dw  G_3_f, G_3, G_2_f, G_2, G_2_f, G_2, G_3_f, G_3, Fs_3_f, Fs_3, F_3_f, F_3, E_3_f, E_3, Ds_3_f, Ds_3, E_3_f, E_3
dw  Gs_2_f, Gs_2, Cs_3_f, Cs_3, C_3_f, C_3, B_2_f, B_2, As_2_f, As_2, A_2_f, A_2, As_2_f, As_2
dw  Ds_2_f, Ds_2, Fs_2_f, Fs_2, Ds_2_f, Ds_2, As_2_f, As_2, G_2_f, G_2, A_2_f, A_2, G_2_f, G_2

dw  G_2_f, G_2, G_2_f, G_2, G_2_f, G_2, Ds_2_f, Ds_2, As_2_f, As_2, G_2_f, G_2, Ds_2_f, Ds_2, As_2_f, As_2, G_2_f, G_2
dw  G_2_f, G_2, G_2_f, G_2, G_2_f, G_2, Ds_2_f, Ds_2, As_2_f, As_2, G_2_f, G_2, Ds_2_f, Ds_2, As_2_f, As_2, G_2_f, G_2

Song_2:
dw  $ff05
dw  D_4_f, D_4, D_4_f, D_4, D_4_f, D_4, G_4_f, G_4, D_5_f, D_5
dw  C_5_f, C_5, B_4_f, B_4, A_4_f, A_4, G_5_f, G_5, D_5_f, D_5
dw  C_5_f, C_5, B_4_f, B_4, A_4_f, A_4, G_5_f, G_5, D_5_f, D_5
dw  C_5_f, C_5, B_4_f, B_4, C_5_f, C_5, A_4_f, A_4

dw  D_4_f, D_4, D_4_f, D_4, D_4_f, D_4, G_4_f, G_4, D_5_f, D_5
dw  C_5_f, C_5, B_4_f, B_4, A_4_f, A_4, G_5_f, G_5, D_5_f, D_5
dw  C_5_f, C_5, B_4_f, B_4, A_4_f, A_4, G_5_f, G_5, D_5_f, D_5
dw  C_5_f, C_5, B_4_f, B_4, C_5_f, C_5, A_4_f, A_4

dw  D_4_f, D_4, D_4_f, D_4, E_4_f, E_4, E_4_f, E_4, C_5_f, C_5, B_4_f, B_4, A_4_f, A_4, G_4_f, G_4, G_4_f, G_4, A_4_f, A_4, B_4_f, B_4, A_4_f, A_4, E_4_f, E_4, Fs_4_f, Fs_4
dw  D_4_f, D_4, D_4_f, D_4, E_4_f, E_4, E_4_f, E_4, C_5_f, C_5, C_5_f, C_5, B_4_f, B_4, A_4_f, A_4, G_4_f, G_4, D_5_f, D_5, D_5_f, D_5, A_4_f, A_4
dw  D_4_f, D_4, D_4_f, D_4, E_4_f, E_4, E_4_f, E_4, C_5_f, C_5, B_4_f, B_4, A_4_f, A_4, G_4_f, G_4, G_4_f, G_4, A_4_f, A_4, B_4_f, B_4, A_4_f, A_4, E_4_f, E_4, Fs_4_f, Fs_4

dw  D_5_f, D_5, D_5_f, D_5, G_5_f, G_5, F_5_f, F_5, Ds_5_f, Ds_5, D_5_f, D_5, C_5_f, C_5, B_4_f, B_4, A_4_f, A_4, G_4_f, G_4, D_5_f, D_5

dw  D_4_f, D_4, D_4_f, D_4, D_4_f, D_4, G_4_f, G_4, D_5_f, D_5
dw  C_5_f, C_5, B_4_f, B_4, A_4_f, A_4, G_5_f, G_5, D_5_f, D_5
dw  C_5_f, C_5, B_4_f, B_4, A_4_f, A_4, G_5_f, G_5, D_5_f, D_5
dw  C_5_f, C_5, B_4_f, B_4, C_5_f, C_5, A_4_f, A_4

dw  $0000