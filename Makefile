
all: batalla.tap

main.tap: main.asm
	pasmo --name batalla --tap main.asm main.tap --public
Int.tap: Int.asm
	pasmo --name int --tap Int.asm Int.tap	


batalla.tap: Int.tap main.tap
	cat Cargador.tap main.tap Int.tap > batalla.tap 

run: batalla.tap
	zesarux batalla.tap
clean:
	rm Int.tap
	rm main.tap
	rm batalla.tap