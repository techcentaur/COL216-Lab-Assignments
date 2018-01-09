	.equ SWI_Exit, 0x11
	
	.data
AA: .word 13
	.text
   	.globl _start

_start:
	ldr r0,=AA
    @stmfd	sp!, {r1,r2,r3,r4,lr}	@ save variables to stack


_square:


_checkHappy:
	cmp r1,#1
	beq _HN
	cmp r1,#7
	beq _HN
	cmp r1,#13
	beq _HN
	mov pc,lr


_end:
	@ldmfd   sp!, {r1,r2,r3,r4,pc}	@ restore state from stack and leave function

_HN:.asciz "Happy Number!!\0"
	swi SWI_Exit
	.end
# a
# visited = set()
# while 1:
#     if a == 1:
#         print "Number is happy!"
#         break
#     a = sum(int(c) ** 2 for c in str(a))
#     if a in visited:
#         print "Number is sad!"
#         break
#     visited.add(a)