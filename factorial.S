# calculate factorial for n

.section .data

.section .text
.globl _start_foo
.globl factorial_foo

_start_foo:
  pushl $5

  call factorial_foo

  addl $4, %esp	# reset stack top

  movl %eax, %ebx
  movl $1, %eax
  int $0x80

.type factorial_foo, @function
factorial_foo:
  pushl %ebp
  movl %esp, %ebp

  movl 8(%ebp), %eax

  cmpl $1, %eax
  je end

  decl %eax

  push %eax
  call factorial_foo

  movl 8(%ebp), %ecx # get old value, this just before it was decremented

  imull %ecx, %eax

  end:
    movl %ebp, %esp
    popl %ebp

    ret
