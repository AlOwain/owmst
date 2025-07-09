
all: build build/coms
build:
	mkdir -p build
clean:
	rm -r ./build

build/coms: build/main.o build/draw.o
	gcc build/main.o build/draw.o -o build/coms -lraylib -lm

build/main.o: src/main.c
	gcc -c src/main.c -o build/main.o

build/draw.o: src/draw.c
	gcc -c src/draw.c -o build/draw.o
	
