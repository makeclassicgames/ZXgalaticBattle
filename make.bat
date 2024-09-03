pasmo --name batalla --tap Main.asm main.tap --public
pasmo --name int --tap Int.asm Int.tap	
copy /b Cargador.tap+MarcianoScr.tap+main.tap+Int.tap batalla.tap 
