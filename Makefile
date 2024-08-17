
all: batalla.tap

batalla.tap: main.asm
	pasmo --name batalla --tapbas main.asm batalla.tap -log

run: batalla.tap
	zesarux batalla.tap
clean:
	rm batalla.tap