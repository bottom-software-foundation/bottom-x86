nasm -f elf32 encode.asm -o encode.o && ld -m elf_i386 encode.o -o encode

nasm -f elf32 decode.asm -o decode.o && ld -m elf_i386 decode.o -o decode
