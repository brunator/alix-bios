# writes dupa 1234! to stdout

.section .data
my_string:
  .string "dupa 1234!\n\0"
my_string_end:

.section .text

.globl _start
_start:
  movl $4, %eax	# write() function call
  movl $1, %ebx	# write to stdout
  movl $my_string, %ecx
  movl $(my_string_end - my_string), %edx

  int $0x80

  movl $1, %eax
  xorl %ebx, %ebx

  int $0x80
