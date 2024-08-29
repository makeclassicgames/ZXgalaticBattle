;direccion graficos definidos por usuario
UDG: EQU $5c7b
;direccion llamada OPENCHAN
OPENCHAN: EQU $1601

ATTR_P: EQU $5c8d
ATTR_T: EQU $5c8f

CLS: EQU $0daf
BORDCR: EQU $5c48
;Constantes de posicionamiento
COR_X: EQU $20; Coordenada x esquina superior izquierda
COR_Y: EQU $18; Coordenada y esquina superior izquierda
MIN_X: EQU $00; A restar de COR_X para x esquina superior izquierda
MIN_Y: EQU $00; A restar de COR_Y para y esquina superior izquierda
MAX_X: EQU $1f; A restar de COR_X para x esquina inferior derecha
MAX_Y: EQU $15; A restar de COR_Y para y esquina inferior derecha

WHITE_GRAPH: EQU $9e ; caracter en blanco
;Constante nave
SHIP_GRAPH: EQU $90 ; Gráfico nave
SHIP_INI: EQU $0511 ; Posicion inicial nave (x,y)
SHIP_TOP_L: EQU $1e ; esquina superior izquierda nave
SHIP_TOP_R: EQU $01 ; esquina superior derechanave

;Codigo de caracter del disparo
FIRE_GRAPH: EQU $91
FIRE_TOP_T: EQU COR_Y

;topes enemigos
ENEMY_TOP_T: EQU COR_Y - MIN_Y
ENEMY_TOP_B: EQU COR_Y - MAX_Y+$01
ENEMY_TOP_L: EQU COR_X - MIN_X
ENEMY_TOP_R: EQU COR_X - MAX_X