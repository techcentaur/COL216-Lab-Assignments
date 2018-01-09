	.equ SWI_Exit, 0x11
	
	.data
AA: .word 13
	.text
   	.globl happyStart:

_happyStart:
	ldr r0,=AA
	

	swi SWI_Exit
	.end