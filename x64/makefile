CC=cc
ASMBIN=nasm
all: asm cc link clean
asm :
	$(ASMBIN) -f elf64 mkama64.asm
cc :
	$(CC) -m64 -std=c11 -c mkam64.c
link :
	$(CC) -m64 -o x64 mkam64.o mkama64.o 
clean :
	rm *.o
