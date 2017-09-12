; Hello World Program
; Compile with: nasm -f elf helloworld.asm
; Link (as 32 bit app.) with: ld -m elf_i386 -o helloworld helloworld.o

section .data
hello   db    'Hello World!', 0xa
hello_end:

section .text
global _start

_start:
  mov eax, 4  ; write() syscall
  mov ebx, 1  ; STDOUT
  mov ecx, hello
  mov edx, (hello_end - hello)
  int 0x80

  sti

  mov eax, 1
  mov ebx, 0
  int 0x80
