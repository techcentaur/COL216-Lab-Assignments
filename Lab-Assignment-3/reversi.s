@Reversi game implemented in ARM assembly langauge
@terminonlogies - r4:flag, r3:increment register, r2:address of board
@ r11:player_no(1 or 2) r10:count
@
@ 1 -> black tile -> LEFT LED
@ 2 -> white tile -> RIGHT LED
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
	swi SWI_CLEAR_DISPLAY

	bl _Initialize
	bl _WelcomeMessage
	bl _setBoard

	swi SWI_CLEAR_DISPLAY
	mov r4,pc
	b _DisplayBoard
	mov r4,pc
	b _DisplayScores
	mov r11,#1
_gameContinue:
	bl _changePlayer
	bl _playerAssign
	bl _checkIfFull
	b _CHECK_IF_MOVE_IS_PRESENT

_Initialize:
	ldr r2,=_score1
	mov r0,#2
	str r0,[r2]
	ldr r2,=_score2
	mov r0,#2
	str r0,[r2]
	ldr r2,=_totalFlips
	mov r0,#0
	str r0,[r2]
	ldr r2,=_IsLastChanceForPlayerWasNotPossible
	mov r0,#0
	str r0,[r2]
	mov pc,lr

_WelcomeMessage:
	mov r0,#4
	mov r1,#1
	ldr r2,=_Welcome
	swi SWI_DRAW_STRING
	mov r0,#5
	mov r1,#2
	ldr r2,=_PlayerInstructionSet
	swi SWI_DRAW_STRING
	mov r0,#5
	mov r1,#4
	ldr r2,=_ButtonInstruction
	swi SWI_DRAW_STRING
	mov r0,#5
	mov r1,#6
	ldr r2,=_LEDInstruction1
	swi SWI_DRAW_STRING
	mov r0,#5
	mov r1,#7
	ldr r2,=_LEDInstruction2
	swi SWI_DRAW_STRING
	mov r0,#5
	mov r1,#9
	ldr r2,=_8SegDisplayInstruction
	swi SWI_DRAW_STRING
	mov r0,#1
	mov r1,#11
	ldr r2,=_EnterButtonInstruction
	swi SWI_DRAW_STRING
	mov r0,#0
_waitforRightBlackButton:
	swi SWI_CheckBlack
	cmp r0,#0
	beq _waitforRightBlackButton
	mov pc,lr

_DisplayBoard:
	mov r7,#0
	mov r8,#0
_loop1Display:
	ldr r2,=_board
	mov r0,#32
	mul r1,r8,r0
	mov r0,#4
	mla r12,r7,r0,r1
	mov r0,r7,LSL#1
	mov r1,r8
	ldr r2,[r2,r12]
	swi SWI_DRAW_INT
	add r7,r7,#1
	cmp r7,#8
	blt _loop1Display
	add r8,r8,#1
	mov r7,#0
	cmp r8,#8
	blt _loop1Display
	mov pc,r4

_processMove:
	bl _readInput
	mov r0,#13
	swi SWI_CLEAR_LINE
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
	ldr r2,=_board
	ldr r1,[r2,r12]
	cmp r1,#0
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
	b _processStep2sub1



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
	b _processStep3sub1

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
	b _processStep4sub1


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
	b _processStep5sub1


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
	b _processStep6sub1


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
	b _processStep7sub1


_processStep8:
	mov r3,#0 @count
	mov r9,#-1
	mov r10,#1
	add r7,r5,r9
	add r8,r6,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _MovementOver
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _MovementOver
	cmp r12,r11
	beq _MovementOver
_processStep8sub1:
	add r3,r3,#1
	add r7,r7,r9
	add r8,r8,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _MovementOver
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _MovementOver
	cmp r12,r11
	moveq r13,pc
	beq _DotheFlipping
	b _processStep8sub1

_MovementOver:
	ldr r0,=_totalFlips
	ldr r2,[r0]
	cmp r2,#0
	beq _InvalidINPUT
	cmp r11,#1
	bne _forplayer2
_forplayer1:
	ldr r0,=_score1
	ldr r2,[r0]
	add r2,r2,#1
	str r2,[r0]

	b _nextInstructionForMovementOver
_forplayer2:
	ldr r0,=_score2
	ldr r2,[r0]
	add r2,r2,#1
	str r2,[r0]

_nextInstructionForMovementOver:
	mov r0,#32
	mul r2,r6,r0
	mov r0,#4
	mla r12,r5,r0,r2
	ldr r2,=_board
	str r11,[r2,r12]
	mov r4,pc
	b _DisplayBoard
	mov r4,pc
	b _DisplayScores
	b _gameContinue

_InvalidINPUT:
	mov r0,#13
	mov r1,#13
	ldr r2,=_InvalidInputPleaseTryAgain
	swi SWI_DRAW_STRING
	b _processMove

_GameOver:
	swi SWI_CLEAR_DISPLAY
	mov r0,#5
	mov r1,#5
	ldr r2,=_GameOverMessage
	swi SWI_DRAW_STRING
	ldr r0,=_score1
	ldr r0,[r0]
	ldr r1,=_score2
	ldr r1,[r1]
	cmp r0,r1
	bgt _player1Wins
	blt _player2Wins
	mov r0,#2
	mov r1,#15
	ldr r2,=_DrawMessage
	swi SWI_DRAW_STRING
	b _GameOverWaitingSaga
	
_player1Wins:
	mov r0,#1
	mov r1,#6
	ldr r2,=_Player1
	swi SWI_DRAW_STRING
	mov r0,#10
	mov r1,#6
	ldr r2,=_WinningMessage
	swi SWI_DRAW_STRING
	b _GameOverWaitingSaga

_player2Wins:
	mov r0,#1
	mov r1,#8
	ldr r2,=_Player2
	swi SWI_DRAW_STRING
	mov r0,#10
	mov r1,#8
	ldr r2,=_WinningMessage
	swi SWI_DRAW_STRING
	b _GameOverWaitingSaga

_GameOverWaitingSaga:
	mov r0,#2
	mov r1,#11
	ldr r2,=_RestartButtonInstruction
	swi SWI_DRAW_STRING
_waitforLeftBlackButton:
	swi SWI_CheckBlack
	cmp r0,#0
	beq _waitforLeftBlackButton
	b _main

_checkIfOnBoard:
	cmp r12,#256
	movlt r4,#1
	mov pc,lr

_notOnBoard:
	mov r0,#13
	mov r1,#13
	ldr r2,=_InvalidInputPleaseTryAgain
	swi SWI_DRAW_STRING
	bl _readInput

@setting the board at the beginning of the game - Rule
_setBoard:
	ldr r2,=_board
	ldr r1,[r2,#108]
	mov r1,#1
	str r1,[r2,#108]
	ldr r1,[r2,#112]
	mov r1,#2
	str r1,[r2,#112]
	ldr r1,[r2,#140]
	mov r1,#2
	str r1,[r2,#140]
	ldr r1,[r2,#144]
	mov r1,#1
	str r1,[r2,#144]
	mov pc,lr

_checkIfFull:
	ldr r2,=_board
	mov r3,#0
_step1:
	ldr r1,[r2,r3]
	cmp r1,#0
	moveq r4,#1 @flag
	moveq pc,lr
	cmp r3,#252
	movle pc,lr
	bgt _GameOver
	add r3,r3,#4
	b _step1


_returnValueAtPostionInR12:
	ldr r2,=_board
	ldr r0,[r2,r12]
	mov r12,r0
	mov pc,lr

_returnAdressInR12:
	mov r0,#32
	mul r2,r8,r0
	mov r0,#4
	mla r12,r7,r0,r2
	mov pc,lr


_DotheFlipping:
	mov r4,#0
	mov r7,r5
	mov r8,r6
_loopInFlipping:
	add r7,r7,r9
	add r8,r8,r10
	bl _returnAdressInR12
	ldr r2,=_board
	str r11,[r2,r12]
	add r4,r4,#1
	cmp r4,r3
	blt _loopInFlipping
	mov r4,pc
	b _ScoresIncrement
	ldr r2,=_totalFlips
	ldr r0,[r2]
	add r0,r0,r3
	str r0,[r2]
	ldr r2,=_IsLastChanceForPlayerWasNotPossible
	mov r0,#0
	str r0,[r2]
	add r13,r13,#4
	mov pc,r13


_ScoresIncrement:
	cmp r11,#1
	beq _scoreP1
	b _scoreP2
_scoreP1:
	ldr r0,=_score1
	ldr r2,[r0]
	add r2,r2,r3
	str r2,[r0]
	ldr r0,=_score2
	ldr r2,[r0]
	sub r2,r2,r3
	str r2,[r0]
	b _DisplayScores
_scoreP2:
	ldr r0,=_score2
	ldr r2,[r0]
	add r2,r2,r3
	str r2,[r0]
	ldr r0,=_score1
	ldr r2,[r0]
	sub r2,r2,r3
	str r2,[r0]
	mov pc,r4

_DisplayScores:
	mov r0,#2
	mov r1,#10
	ldr r2,=_scorePlayer1
	swi SWI_DRAW_STRING
	ldr r2,=_score1
	mov r0,#20
	mov r1,#10
	ldr r2,[r2]
	swi SWI_DRAW_INT
	mov r0,#2
	mov r1,#11
	ldr r2,=_scorePlayer2
	swi SWI_DRAW_STRING
	ldr r2,=_score2
	mov r0,#20
	mov r1,#11
	ldr r2,[r2]
	swi SWI_DRAW_INT
	mov pc,r4

_readInput:
	ldr r0,=_totalFlips
	mov r2,#0
	str r2,[r0]
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


_changePlayer:
	cmp r11,#1
	moveq r11,#2
	moveq pc,lr
	cmp r11,#2
	moveq r11,#1
	mov pc,lr

_playerAssign:
	cmp r11,#2
	beq _RightLED
_leftLED:
	mov r0,#0x02
	swi SWI_SETLED @left
	ldr r0,=SEG_B|SEG_C
	swi SWI_SETSEG8
	mov pc,lr
_RightLED:
	mov r0,#0x01
	swi SWI_SETLED @right
	ldr r0,=SEG_B|SEG_A|SEG_F|SEG_E|SEG_D
	swi SWI_SETSEG8
	mov pc,lr


_processMoveChecking:
	@(r5,r6) -> coordinates input on board
	mov r7,r5
	mov r8,r6
_processStep1MoveChecking:
	mov r9,#1
	mov r10,#0
	add r7,r5,r9
	add r8,r6,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStepMoveChecking2
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStepMoveChecking2
	cmp r12,r11
	beq _processStepMoveChecking2
_processStep1sub1MoveChecking:
	add r7,r7,r9
	add r8,r8,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStepMoveChecking2
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStepMoveChecking2
	cmp r12,r11
	beq _FlipPossibilityExists
	b _processStep1sub1MoveChecking


_processStepMoveChecking2:
	mov r9,#1
	mov r10,#1
	add r7,r5,r9
	add r8,r6,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep3MoveChecking
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep3MoveChecking
	cmp r12,r11
	beq _processStep3MoveChecking
_processStep2sub1MoveChecking:
	add r7,r7,r9
	add r8,r8,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep3MoveChecking
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep3MoveChecking
	cmp r12,r11
	beq _FlipPossibilityExists
	b _processStep2sub1MoveChecking

_processStep3MoveChecking:
	mov r9,#0
	mov r10,#1
	add r7,r5,r9
	add r8,r6,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep4MoveChecking
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep4MoveChecking
	cmp r12,r11
	beq _processStep4MoveChecking
_processStep3sub1MoveChecking:
	add r7,r7,r9
	add r8,r8,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep4MoveChecking
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep4MoveChecking
	cmp r12,r11
	beq _FlipPossibilityExists
	b _processStep3sub1MoveChecking

_processStep4MoveChecking:
	mov r9,#1
	mov r10,#-1
	add r7,r5,r9
	add r8,r6,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep5MoveChecking
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep5MoveChecking
	cmp r12,r11
	beq _processStep5MoveChecking
_processStep4sub1MoveChecking:
	add r7,r7,r9
	add r8,r8,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep5MoveChecking
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep5MoveChecking
	cmp r12,r11
	beq _FlipPossibilityExists
	b _processStep4sub1MoveChecking

_processStep5MoveChecking:
	mov r9,#0
	mov r10,#-1
	add r7,r5,r9
	add r8,r6,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep6MoveChecking
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep6MoveChecking
	cmp r12,r11
	beq _processStep6MoveChecking
_processStep5sub1MoveChecking:
	add r7,r7,r9
	add r8,r8,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep6MoveChecking
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep6MoveChecking
	cmp r12,r11
	beq _FlipPossibilityExists
	b _processStep5sub1MoveChecking

_processStep6MoveChecking:
	mov r9,#-1
	mov r10,#-1
	add r7,r5,r9
	add r8,r6,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep7MoveChecking
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep7MoveChecking
	cmp r12,r11
	beq _processStep7MoveChecking
_processStep6sub1MoveChecking:
	add r7,r7,r9
	add r8,r8,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep7MoveChecking
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep7MoveChecking
	cmp r12,r11
	beq _FlipPossibilityExists
	b _processStep6sub1MoveChecking

_processStep7MoveChecking:
	mov r9,#-1
	mov r10,#0
	add r7,r5,r9
	add r8,r6,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep8MoveChecking
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep8MoveChecking
	cmp r12,r11
	beq _processStep8MoveChecking
_processStep7sub1MoveChecking:
	add r7,r7,r9
	add r8,r8,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _processStep8MoveChecking
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _processStep8MoveChecking
	cmp r12,r11
	beq _FlipPossibilityExists
	b _processStep7sub1MoveChecking

_processStep8MoveChecking:
	mov r9,#-1
	mov r10,#1
	add r7,r5,r9
	add r8,r6,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _MovementOverMoveChecking
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _MovementOverMoveChecking
	cmp r12,r11
	beq _MovementOverMoveChecking
_processStep8sub1MoveChecking:
	add r7,r7,r9
	add r8,r8,r10
	bl _returnAdressInR12 @set r12 to (r7,r8) address
	bl _checkIfOnBoard
	cmp r4,#1
	bne _MovementOverMoveChecking
	bl _returnValueAtPostionInR12 @value stored at (r7,r8) address
	cmp r12,#0
	beq _MovementOverMoveChecking
	cmp r12,r11
	beq _FlipPossibilityExists
	b _processStep8sub1MoveChecking

_FlipPossibilityExists:
	b _processMove

_MovementOverMoveChecking:
	add r2,r5,r6
	cmp r2,#14
	bge _ShowMessageThatNoChance
	mov pc,r1

_CHECK_IF_MOVE_IS_PRESENT:
	mov r5,#0
	mov r6,#0
_loop1CHECK_IF_MOVE_IS_PRESENT:
	mov r0,#32
	mul r1,r6,r0
	mov r0,#4
	mla r12,r5,r0,r1
	ldr r2,=_board
	ldr r1,[r2,r12]
	cmp r1,#0
	moveq r1,pc
	beq _processMoveChecking
	add r5,r5,#1
	cmp r5,#8
	blt _loop1CHECK_IF_MOVE_IS_PRESENT
	add r6,r6,#1
	mov r5,#0
	cmp r6,#8
	blt _loop1CHECK_IF_MOVE_IS_PRESENT


_ShowMessageThatNoChance:
	mov r0,#15
	mov r1,#10
	ldr r2,=_MessageForNoChance
	swi SWI_DRAW_STRING
	ldr r2,=_IsLastChanceForPlayerWasNotPossible
	ldr r1,[r2]
	cmp r1,#1
	beq _GameOver
	mov r1,#1
	str r1,[r2]
	b _gameContinue

_end:
	swi SWI_EXIT

.data
_board: .space 256
_inputKeyboardXCoordinate: .space 4
_inputKeyboardYCoordinate: .space 4
_score1: .space 4
_score2: .space 4
_totalFlips: .space 4
_IsLastChanceForPlayerWasNotPossible: .space 4 
_scorePlayer1: .asciz "Score-Player1:"
_scorePlayer2: .asciz "Score-Player2:"
_fullBoardAlert: .asciz "Board is Full!\n"
_NotOnBoardAlert: .asciz "Position not on Board\n"
_Welcome: .asciz "Welcome to the Game - Reversi\n"
_PlayerInstructionSet: .asciz "1 -> Player1 : 2 ->Player2\n"
_LEDInstruction1: .asciz "Left Red LED -> Player1\n"
_LEDInstruction2: .asciz  "Right Red LED -> Player2\n"
_ButtonInstruction: .asciz "Left Black Button - Reset\n"
_EnterButtonInstruction: .asciz "Press Right-Button(Enter) to continue\n"
_RestartButtonInstruction: .asciz "Press Left-Button(Enter) to restart\n"
_8SegDisplayInstruction: .asciz "Lookout Display for Import Info.\n"
_GameOverMessage: .asciz "Game-Over\n"
_WinningMessage: .asciz "Wins!"
_Player1: .asciz "Player1"
_Player2: .asciz "Player2"
_DrawMessage: .asciz "It's A Draw!\n"
_MessageForNoChance: .asciz "No Moves! Chances switch to next player"
_InvalidInputPleaseTryAgain: .asciz "Invalid Input! Try again"
_herecomesthedebugger: .asciz "Debugger!!"
_None: .asciz " \n"