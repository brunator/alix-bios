	.file	"chararg.c"
	.text
	.p2align 4,,15
	.globl	chararg_foo
	.type	chararg_foo, @function
chararg_foo:
.LFB0:
	.cfi_startproc
	movl	4(%esp), %edx
	xorl	%eax, %eax
	cmpb	$0, (%edx)
	je	.L4
	.p2align 4,,10
	.p2align 3
.L3:
	addl	$1, %eax
	cmpb	$0, (%edx,%eax)
	jne	.L3
	rep ret
.L4:
	rep ret
	.cfi_endproc
.LFE0:
	.size	chararg_foo, .-chararg_foo
	.ident	"GCC: (Debian 6.3.0-18) 6.3.0 20170516"
	.section	.note.GNU-stack,"",@progbits
