
all: batalla.tap

main.tap: main.asm
	pasmo --name batalla --tap main.asm main.tap --log
int.tap: int.asm
	pasmo --name int --tap int.asm int.tap
batalla.tap: main.tap int.tap Cargador.tap
	cat Cargador.tap main.tap int.tap > batalla.tap
run: 
	zesarux batalla.tap
clean:
	rm int.tap
	rm main.tap
	rm batalla.tap
	