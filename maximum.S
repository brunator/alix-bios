#Find maximum value in a given integer number data items.
#
# %edi - holds the index of data item being examined
# %ebx - current larges data item
# %eax - current examined data item (this indexed with %edi)

.section .data

data_items:  # table of integers being examined
  .long 253,67,34,222,45,75,54,34,44,251, 33,22,11,66,95,0

.section .text

.globl _start
_start:
  movl data_items(,0,4), %ebx	# assume we have greates values
  cmpl $0, %ebx	  # check exit condition
  je proc_exit
#  movl $0, %edi
#  movl data_items(,%edi,4), %eax
#  movl %eax, %ebx

  movl $1, %edi	# %edi is set to 1 since item indexed with 0 is
		# already moved to %ebx
proc_loop:  # main processing loop
  movl data_items(,%edi,4), %eax
  cmpl $0, %eax	  # check exit condition
  je proc_exit

#  movl data_items(,%edi,4), %eax
  cmpl %ebx, %eax # calculate x = %ebx - %eax; if x > 0 then %eax is lesser than
		  # %ebx; if x < 0 then %eax is greater than %ebx; if x == 0
		  # %eax == %ebx
  jle proc_loop	# jump to the begin of processing loop in case %eax is less or
		# equal %ebx
  movl %eax, %ebx # store current greatest value in %ebx

  incl %edi # increment index; it points to next data_items item
  jmp proc_loop

proc_exit:
  # the greates values is returned to OS in %ebx as exit() parameter
  movl $1, %eax
  int $0x80

