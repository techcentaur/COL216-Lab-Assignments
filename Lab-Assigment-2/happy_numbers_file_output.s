	.equ SWI_Open, 0x66
	.equ SWI_Close, 0x68
	.equ SWI_PrInt, 0x6b
	.equ SWI_Exit, 0x11
	.equ SWI_PrStr, 0x69
	.equ Stdout, 1
	.text
	.globl _start

@start the program
_start:
	ldr r0,=InFileName
	mov r1,#1 @output mode
	swi SWI_Open
	bcs _NoFileFound
	ldr r1,=OutFileHandle
	str r0,[r1]
	mov r5,#10
	mov r10,#1000
	mul r9,r5,r10
	mov r2,#0

@start the loop of 10000 numbers
_loop1000:
	add r2,r2,#1
	mov r3,r2

	cmp r3,r9
	bge _closeAndEnd
	cmp r3,#13
	mov r8,r3
	ble _checkIfHappy
	bl _makeItOneDigit

@make the number in r2 one digit by squaring the individual bits and suming them up
_makeItOneDigit:
	cmp r3,#10
	mov r4,#1
	blt _step2
	cmp r3,#100
	mov r4,#10
	blt _step2
	cmp r3,#1000
	mov r4,#100
	blt _step2
	mov r4,#1000
	bl _step2
_step2:
	mov r5,#0
_step3:
	sub r3,r3,r4
	add r5,r5,#1
	cmp r3,r4
	bge _step3
	mul r6,r5,r5
	add r7,r7,r6
	cmp r3,#0
	moveq r8,r7
	beq _checkIfHappy
	bl _makeItOneDigit
_step4:
	mov r3,r7
	mov r7,#0
	bl _makeItOneDigit
_step5:
	mov r7,#0
	bl _loop1000

@check if the number is happy or not
_checkIfHappy:
	cmp r8,#1
	beq _isHappy
	cmp r8,#7
	beq _isHappy
	cmp r8,#10
	beq _isHappy
	cmp r8,#13
	beq _isHappy
	cmp r8,#13
	blt _step5
	cmp r8,r2
	beq _step5
	bl _step4

@the number is happy and thus write it in file
_isHappy:
	mov r1,r2
	bl _writeInFile

@write the number stored in r1 in file whose handle is stored in r0
_writeInFile:
	ldr r0,=OutFileHandle
	ldr r0,[r0]
	swi SWI_PrInt
	ldr r1,=Enter
	swi SWI_PrStr
	bl _step5

@No file found error
_NoFileFound:
	mov r0, #Stdout
	ldr r1,=FileError
	swi SWI_PrStr
	swi SWI_Exit

@Close the file and end the program
_closeAndEnd:
	ldr r0,=OutFileHandle
	ldr r0,[r0]
	swi SWI_Close
	swi SWI_Exit


	.data
OutFileHandle: 
	.word 0
InFileName:   
	.asciz "output.txt"
Enter:
	.asciz "\n"
FileError: 
	.asciz "File open failed"
	.end
	swi SWI_Exit