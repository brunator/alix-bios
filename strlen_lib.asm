; Calculate string length
; Compile with: nasm -f elf strlem_lib.asm
; Linked with: gcc -m32 -Wall -g0 -O0 -o strlen_lib strlen_lib.o strlen_main.o

section .text
global strlen_asm

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
