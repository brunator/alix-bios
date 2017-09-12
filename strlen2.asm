; Calculate string length
; Compile with: nasm -f elf strlen2.asm
; Linked with: ld -m elf_i386 -o strlen2 strlen2.o

section .data
  hello_str db 'Xxxxx, xxxxx xxx xxxxx!', 0xa ; new line char. at the end
  str4 db 'dupa!'

section .text
global _start
global strlen_asm

_start:
  mov eax, str4
  push eax
  call strlen_asm

  add esp, 4

  mov ebx, eax
  mov eax, 1
  int 0x80

strlen_asm:
  push ebp
  mov esp, ebp

  ; ESP - old EBP
  ; ESP + 4 - return address
  ; get string pointer
  lea eax, [ebp+8] ; move adress of string to EBX
  mov edx, eax

  check_char:
    cmp byte[eax], 0 ; compare the byte(char) pointed to by ECX at
                     ; this address against zero
    je check_end

    inc eax
    jmp check_char

  check_end:
    sub eax, edx

  ; restore ESP
  mov ebp, esp
  pop ebp ; restore old EBP

  ret
