	.equ SWI_Exit, 0x11
	
	.data
AA:	.word 2,6,3,9,4,7
	
	.text
   	.globl _start

_start:
	ldr r0,=AA 			
	
	mov r2,#6
	sub r2,r2,#1
	
	mov r8,#4
	mul r1,r2,r8
	mov r2,r1

_loop: 				
	mov r3,#0	

_L:	ldr r4,[r0,r3]
	add r7, r3,#4
	ldr r5,[r0,r7]
	
	cmp r4,r5
	ble _cn

_swap:
	str r4,[r0,r7]
	str r5,[r0,r3]

_cn:
	add r3,r3,#4
	cmp r3,r1
	blt _L

_ok:
	sub r1,r1,#4
	cmp r1,#0
	bne _loop

	swi SWI_Exit
	.end


# Bubble sort - 
# void bsort(int arr, int n){
# 	for(int i=0;i<n-1;i++){
# 		for(int j=0,j<n-1-i;j++){
# 			if arr[j+1]<arr[j]{
# 				swap(arr[j+1],arr[j])s}}}}
# void swap(int *a, int *b){
# 	temp =*a
# 	*a=*b
# 	*b=temp}