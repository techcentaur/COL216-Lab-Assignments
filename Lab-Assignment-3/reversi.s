@Reversi game implemented in ARM assembly langauge
@terminonlogies - r4:flag, r3:increment register, r2:address of board
@ r11:player_no(1 or -1) r10:count
@
@-1 -> black tile -> LEFT LED
@ 1 -> white tile -> RIGHT LED
@ 0 -> no tile

	.equ SWI_SETSEG8,0x200
	.equ SWI_SETLED,0x201
	.equ SWI_CheckBlack, 0x202
	.equ SWI_CheckBlue,0x203
	.equ SWI_DRAW_STRING, 0x204
	.equ SWI_DRAW_INT,0x205
	.equ SWI_CLEAR_DISPLAY,0x206
	.equ SWI_DRAW_CHAR,0x207
	.equ SWI_CLEAR_LINE, 0x208
	.equ SWI_EXIT, 0x11	
	.equ SWI_GetTicks, 0x6d
	.equ SEG_A, 0x80
	.equ SEG_B, 0x40
	.equ SEG_C, 0x20
	.equ SEG_D, 0x08
	.equ SEG_E, 0x04
	.equ SEG_F, 0x02
	.equ SEG_G, 0x01
	.equ SEG_P, 0x10
	.equ LEFT_LED, 0x02
	.equ RIGHT_LED, 0x01
	.equ LEFT_BLACK_BUTTON,0x02
	.equ RIGHT_BLACK_BUTTON,0x01
	.equ BLUE_KEY_00, 0x01
	.equ BLUE_KEY_01, 0x02
	.equ BLUE_KEY_02, 0x04
	.equ BLUE_KEY_03, 0x08
	.equ BLUE_KEY_04, 0x10
	.equ BLUE_KEY_05, 0x20
	.equ BLUE_KEY_06, 0x40
	.equ BLUE_KEY_07, 0x80
	.equ BLUE_KEY_00, 1<<8
	.equ BLUE_KEY_01, 1<<9
	.equ BLUE_KEY_02, 1<<10
	.equ BLUE_KEY_03, 1<<11
	.equ BLUE_KEY_04, 1<<12
	.equ BLUE_KEY_05, 1<<13
	.equ BLUE_KEY_06, 1<<14
	.equ BLUE_KEY_07, 1<<15
	.text
	.globl _main


_main:
	bl _setBoard
	mov r11,#1
_gameContinue:
	bl _playerAssign
	b _processMove


_processMove:
	bl _readInput
	ldr r5,=_inputKeyboardXCoordinate
	ldr r6,=_inputKeyboardYCoordinate
	ldr r5,[r5]
	ldr r6,[r6]
	@(r5,r6) -> coordinates input on board
	mov r7,r5
	mov r8,r6
	bl _returnAdressInR12
	bl _checkIfOnBoard
	cmp r4,#1
	bne _notOnBoard
	

_processStep1:
	mov r3,#0 @count
	mov r9,#1
	mov r10,#0
	add r7,r5,r9
	add r8,r6,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep2
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep2
	cmp r12,r11
	beq _processStep2
_processStep1sub1:
	add r3,r3,#1
	add r7,r7,r9
	add r8,r8,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep2
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep2
	cmp r12,r11
	moveq r13,pc
	beq _DotheFlipping
	b _processStep1sub1


_processStep2:
	mov r3,#0 @count
	mov r9,#1
	mov r10,#1
	add r7,r5,r9
	add r8,r6,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep3
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep3
	cmp r12,r11
	beq _processStep3
_processStep2sub1:
	add r3,r3,#1
	add r7,r7,r9
	add r8,r8,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep3
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep3
	cmp r12,r11
	moveq r13,pc
	beq _DotheFlipping
	b _processStep1sub1



_processStep3:
	mov r3,#0 @count
	mov r9,#0
	mov r10,#1
	add r7,r5,r9
	add r8,r6,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep4
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep4
	cmp r12,r11
	beq _processStep4
_processStep3sub1:
	add r3,r3,#1
	add r7,r7,r9
	add r8,r8,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep4
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep4
	cmp r12,r11
	moveq r13,pc
	beq _DotheFlipping
	b _processStep1sub1

_processStep4:
	mov r3,#0 @count
	mov r9,#1
	mov r10,#-1
	add r7,r5,r9
	add r8,r6,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep5
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep5
	cmp r12,r11
	beq _processStep5
_processStep4sub1:
	add r3,r3,#1
	add r7,r7,r9
	add r8,r8,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep5
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep5
	cmp r12,r11
	moveq r13,pc
	beq _DotheFlipping
	b _processStep1sub1


_processStep5:
	mov r3,#0 @count
	mov r9,#0
	mov r10,#-1
	add r7,r5,r9
	add r8,r6,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep6
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep6
	cmp r12,r11
	beq _processStep6
_processStep5sub1:
	add r3,r3,#1
	add r7,r7,r9
	add r8,r8,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep6
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep6
	cmp r12,r11
	moveq r13,pc
	beq _DotheFlipping
	b _processStep1sub1


_processStep6:
	mov r3,#0 @count
	mov r9,#-1
	mov r10,#-1
	add r7,r5,r9
	add r8,r6,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep7
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep7
	cmp r12,r11
	beq _processStep7
_processStep6sub1:
	add r3,r3,#1
	add r7,r7,r9
	add r8,r8,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep7
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep7
	cmp r12,r11
	moveq r13,pc
	beq _DotheFlipping
	b _processStep1sub1


_processStep7:
	mov r3,#0 @count
	mov r9,#-1
	mov r10,#0
	add r7,r5,r9
	add r8,r6,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep8
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep8
	cmp r12,r11
	beq _processStep8
_processStep7sub1:
	add r3,r3,#1
	add r7,r7,r9
	add r8,r8,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep8
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep8
	cmp r12,r11
	moveq r13,pc
	beq _DotheFlipping
	b _processStep1sub1


_processStep8:
	mov r3,#0 @count
	mov r9,#-1
	mov r10,#1
	add r7,r5,r9
	add r8,r6,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep8
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep8
	cmp r12,r11
	beq _processStep8
_processStep8sub1:
	add r3,r3,#1
	add r7,r7,r9
	add r8,r8,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep8
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep8
	cmp r12,r11
	moveq r13,pc
	beq _DotheFlipping
	b _processStep1sub1

_MovementOver:
	b _gameContinue

_checkIfOnBoard:
	cmp r12,#256
	movlt r4,#1
	mov pc,lr
_boardFull:
	ldr r1,=_fullBoardAlert
_notOnBoard:
	ldr r1,=_NotOnBoardAlert

_setBoard:
	ldr r2,=_board
	ldr r1,[r2,#108]
	mov r1,#1
	str r1,[r2,#108]
	ldr r1,[r2,#112]
	mov r1,#-1
	str r1,[r2,#112]
	ldr r1,[r2,#140]
	mov r1,#-1
	str r1,[r2,#140]
	ldr r1,[r2,#144]
	mov r1,#1
	str r1,[r2,#144]
	mov pc,lr

_clearEmbestBoard:
	swi SWI_CLEAR_DISPLAY
	swi SWI_SETSEG8
	mov r0,#0
	swi SWI_SETLED
	mov r0,#0
	swi SWI_SETSEG8

_checkIfFull:
	ldr r2,=_board
	mov r3,#0
_step1:
	ldr r1,[r2,r3]
	cmp r1,#0
	moveq r4,#1 @flag
	moveq pc,lr
	cmp r3,#252
	moveq pc,lr
	add r3,r3,#4
	b _step1


_returnValueAtPostionInR12:
	ldr r2,=_board
	ldr r0,[r2,r12]
	mov r12,r0
	mov pc,lr
_returnAdressInR12:
	mov r0,#8
	mul r1,r5,r0
	add r1,r1,r6
	mov r0,#4
	mul r12,r1,r0
	mov pc,lr


_DotheFlipping:
	mov r4,#0
	ldr r2,=_board
	mov r7,r5
	mov r8,r6
	bl _returnAdressInR12
	str r11,[r12]
_loopInFlipping:
	add r7,r7,r9
	add r8,r8,r10
	bl _returnAdressInR12
	str r11,[r12]
	add r4,r4,#1
	cmp r3,r4
	blt _loopInFlipping
	add r13,r13,#4
	mov pc,r13


_readInput:
	ldr r4,=_inputKeyboardXCoordinate
_stepInputX:
	swi 0x203
	cmp r0,#0
	beq _stepInputX
	mov r3,#0
	tst r0,#255
	addeq r3,r3,#8
	moveq r0,r0,LSR#8
	tst r0,#15
	addeq r3,r3,#4
	moveq r0,r0,LSR#4
	tst r0,#3
	addeq r3,r3,#2
	moveq r0,r0,LSR#2
	tst r0,#1
	addeq r3,r3,#1
	moveq r0,r0,LSR#1
	str r3,[r4]
_readInputAdditional:
	ldr r4,=_inputKeyboardYCoordinate
_stepInputY:
	swi 0x203
	cmp r0,#0
	beq _stepInputY
	mov r3,#0
	tst r0,#255
	addeq r3,r3,#8
	moveq r0,r0,LSR#8
	tst r0,#15
	addeq r3,r3,#4
	moveq r0,r0,LSR#4
	tst r0,#3
	addeq r3,r3,#2
	moveq r0,r0,LSR#2
	tst r0,#1
	addeq r3,r3,#1
	moveq r0,r0,LSR#1
	str r3,[r4]
	mov pc,lr

_playerAssign:
	cmp r11,#-1
	beq _RightLED
_leftLED:
	mov r0,#0x02
	swi SWI_SETLED @left
	mov pc,lr
_RightLED:
	mov r0,#0x01
	swi SWI_SETLED @right
	mov pc,lr





_end:
	swi SWI_EXIT


.data
_board: .space 256
_inputKeyboardXCoordinate: .space 4
_inputKeyboardYCoordinate: .space 4
_score1: .space 4
_score2: .space 4
_fullBoardAlert: .asciz "Board is Full!\n"
_NotOnBoardAlert: .asciz "Position not on Board\n"