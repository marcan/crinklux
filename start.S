
.extern main
.globl _start
.text
_start:
	pop		%esi
	mov		%esp, %ecx
	push	%ecx
	push	%esi
	call	main
	movl	%eax, %ebx
	xorl    %eax, %eax
	incl    %eax
	int		$0x80
