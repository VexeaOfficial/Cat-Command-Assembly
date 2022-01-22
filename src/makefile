cat: cat.o utilities.o
		gcc -o ../bin/cat cat.o utilities.o -no-pie -lc

cat.o: cat.asm
		nasm -f elf64 -g -F dwarf cat.asm -l ../bin/cat.lst

utilities.o: utilities.asm
	nasm -f elf64 -g -F dwarf utilities.asm -l ../bin/utilities.lst
