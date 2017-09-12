; Calculate string length
; Compile with: nasm -f elf strlem.asm
; Linked with (-m elf_i386 for x86_64): ld -m elf_i386 -o strlen strlen.o

section .data
  hello_str db 'Xxxxx, xxxxx xxx xxxxx!', 0xa ; new line char. at the end
  str4 db 'dupa!'

section .text
global _start

_start:
  mov ebx, str4 ; move adress of string to EBX
  mov eax, ebx

  check_char:
    cmp byte[ebx], 0 ; compare the byte(char) pointed to by ECX at
                     ; this address against zero
    je check_end

    inc ebx
    jmp check_char

  check_end:
    sub ebx, eax

  ; return string length to OS
  mov eax, 1 ; ebx is already set to string length
  int 0x80
