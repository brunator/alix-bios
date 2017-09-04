# Calculate power of two integer number

.section .data

.section .text
.globl _start:
_start:

  pushl $3
  pushl $2
  call power_foo
  addl $8, $esp # cleanup stack

  pushl %eax # store curren power_foo result on stack

  pushl $2
  pushl $5
  call power_foo
  addl $8, %esp # cleanup stack
  pushl %ebp
  movl %esp, %ebp

  subl $8, %esp # make room for function parameters
