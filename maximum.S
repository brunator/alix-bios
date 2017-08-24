#Find maximum value in a given integer number data items.
#
# %edi - holds the index of data item being examined
# %ebx - current larges data item
# %eax - current examined data item (this indexed with %edi)

.section .data

data_items:  # table of integers being examined
  .long 253,67,34,222,45,75,54,34,44,251,33,22,11,66,95,9,254,0
data_end:

.globl hex_data
hex_data:
  .short 0xdeade, 0xbeef, 0xfeda, 0xb1da, 0x9999

hello_text:
  .ascii "Hello\tWorld!\n\0"
label1:

.section .text

.globl _start
_start:

  movl $0x80000000, %ebx # the smallest 32-bit number
#  movl data_items(,%edi,4), %ebx # assume we have greates values
#  cmpl $0, %ebx	  # check exit condition
#  je proc_exit
#  movl $0, %edi
#  movl data_items(,%edi,4), %eax
#  movl %eax, %ebx

  xorl %edi, %edi # zeoring %edi register
proc_loop:  # main processing loop
  cmpl $((data_end - data_items) / 4), %edi # check exit condition
  jge proc_exit	# %edi >= $((data_end - data_items) / 4)

  movl data_items(,%edi,4), %eax
  incl %edi # increment index; it points to next data_items item
#  cmpl $0, %eax
#  je proc_exit

#  movl data_items(,%edi,4), %eax
  cmpl %ebx, %eax # calculate x = %ebx - %eax; if x > 0 then %eax is lesser than
		  # %ebx; if x < 0 then %eax is greater than %ebx; if x == 0
		  # %eax == %ebx
  jle proc_loop	# jump to the begin of processing loop in case %eax is less or
		# equal %ebx
		# %eax <= %ebx
  movl %eax, %ebx # store current greatest value in %ebx

  jmp proc_loop

proc_exit:
  # the greates values is returned to OS in %ebx as exit() parameter
  movl $1, %eax
  int $0x80

