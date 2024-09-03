
all: batalla.tap

main.tap: Main.asm
	pasmo --name batalla --tap Main.asm main.tap --public
Int.tap: Int.asm
	pasmo --name int --tap Int.asm Int.tap	


batalla.tap: Int.tap main.tap
	cat Cargador.tap MarcianoScr.tap main.tap Int.tap > batalla.tap 

run: batalla.tap
	zesarux batalla.tap
clean:
	rm Int.tap
	rm main.tap
	rm batalla.tap