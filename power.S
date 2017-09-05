# Calculate the sum of power of two integer number:
# s = i^j + k^l

.section .data

.section .text
.globl _start
_start:

  pushl $3
  pushl $2
  call power_foo
  addl $8, %esp # cleanup stack

  pushl %eax # store curren power_foo result on stack

  pushl $2
  pushl $5
  call power_foo
  addl $8, %esp # cleanup stack

  popl %ebx
  addl %eax, %ebx

  movl $1, %eax
  int $0x80

.type power_foo, @function
power_foo:
  # stack very top point to very next instruction after power_foo call
  # do standard Linux function stuff:
  pushl %ebp # store current base register content on the stack
             # stack very top contains %ebp register
  movl %esp, %ebp # set base registe to point stack; %ebp
                  # contains current stack very top
#  subl $4, %esp # reserve memory for local variable

  # get function paremeters
  movl 12(%ebp), %ecx # power base - 1st argument
  movl 8(%ebp), %edx # power exponent - 2nd argument

  movl $1, %eax

calc_loop:
  cmpl $0, %ebx
  jg stop

  imull %ecx, %eax

  decl %ebx
  jmp calc_loop

stop:

  # restore stack
  movl %ebp, %esp
  popl %ebp
  ret
