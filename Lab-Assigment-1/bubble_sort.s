	.equ SWI_Exit, 0x11
	.text
   	.globl _start
_start:
	mov r0,#4 			@ r0=4
	ldr r1,[r2] 		@ first address ->r1
	ldr r2,[r3]			@ no-of-numbers -> r2
@	cmp r2,#1  			@ if r2<1
@	ble _breakout		@ break
	b _outerloop

@_breakout:
@	swi     0x11	@ invoke syscall

_outerloop:
	mov r3,#0 			@ r3 => i=0
	sub r2,r2,#1		@ r2 => n-1
	b _innerloop
	cmp r3,r2			@ for all <n-1
	add r3,r3,#1
	ble _outerloop

_innerloop:
	mov r4,#0			@ j=0
	sub r5,r2,r3 		@ n-1-j
	b _check
	cmp r4,r5
	add r4,r4,#1
	ble _innerloop

_check:
	mul r6,r4,r0 		@r6 = the offset for the no.
	ldr r7,[r1,r6]
	ldr r8,[r7,#4]		@ r7,r8 are 2 numbers
	cmp r7,r8			
	bgt _swap			@ if r7 greater than r8
	mov pc,lr

_swap:
	ldr r9,[r8]			@sawping values
	str r7,[r8]
	str r8,[r9]
	mov pc,lr

	swi SWI_Exit
	.end


# void bsort(int arr, int n){
# 	for(int i=0;i<n-1;i++){
# 		for(int j=0,j<n-1-i;j++){
# 			if arr[j+1]<arr[j]{
# 				swap(arr[j+1],arr[j])s}}}}
# void swap(int *a, int *b){
# 	temp =*a
# 	*a=*b
# 	*b=temp}