CC=cc
ASMBIN=nasm
all: asm cc link clean
asm :
	$(ASMBIN) -f elf mkama32.asm
cc :
	$(CC) -m32 -std=c11 -c mkam32.c
link :
	$(CC) -m32 -o x32 mkam32.o mkama32.o
clean :
	rm *.o
