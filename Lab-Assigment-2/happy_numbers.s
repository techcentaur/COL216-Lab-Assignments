	.equ SWI_Exit, 0x11
	.data
	.text
   	.globl _start

_start:
	mov r1,#68
	mov r6,r1
	mov r2,#10
	b _compare

_redo_r5:
	mov r5,#0

_compare:
	cmp r1,r2
	mov r2,#1
	blt _continue
	mov r2,#100
	cmp r1,#100
	mov r2,#10
	blt _continue
	mov r2,#1000
	cmp r1,r2
	mov r2,#100
	blt _continue
	mov r2,#1000

_continue:
	mov r3,#0 

_sub:
	sub r1,r1,r2
	add r3,r3,#1
	cmp r1,r2
	bge _sub

_square:
	mul r4,r3,r3
	add r5,r5,r4
	cmp r1,#0
	beq _check
	b _compare

_again:
	mov r1,r5
	b _redo_r5

_check:
	cmp r5,#1
	beq _happy
	cmp r5,#7
	beq _happy
	cmp r5,#10
	beq _happy
	cmp r5,r6
	beq _happy
	cmp r5,#10
	ble _end
	b _again

_happy:
	ldr r7,=_HN
	swi 0X02

_end:
	.data
_HN:.ascii "Happy Number!!\0"
	swi SWI_Exit
	.end



    @stmfd	sp!, {r1,r2,r3,r4,lr}	@ save variables to stack	
	@ldmfd   sp!, {r1,r2,r3,r4,pc}	@ restore state from stack and leave function
