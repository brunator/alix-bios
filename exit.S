.section .data

.section .text
.globl _start
_start:
  xor %rax, %rax
  movq $1, %rax	    # this is the linux kernel command number
		    # (system call) for exiting a program: exit() function

  movq $-1, %rbx	    # value of funcion void exit(int status) param. status

  int $0x80	    # hexadecimal value of kernel procedure calling of exit()

