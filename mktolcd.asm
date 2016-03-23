

; ######################################################
;
;	Программа под MK AT89C2051 
;	для работы с дисплеем MT-12232A
;
;
; ZeLDER
; ######################################################





; ++++++++++++++++++++++++++++++++++++++++++++++++++++
;
;				PORTS
;	
;	P1 out to LCD (8 bit data line)
;
;	P3 out to LCD (commands)
;	P3.:
;		0 - E
;		1 - RW
;		2 - A0
;		3 - CS
;		4 - RES
;		5 - 
;		7 -
;
; ++++++++++++++++++++++++++++++++++++++++++++++++++++
	LCD_E 	EQU P3.0
	LCD_RW 	EQU P3.1
	LCD_A0 	EQU P3.2
	LCD_CS	EQU P3.3
	LCD_RES	EQU P3.4

	PPLED	EQU P3.7
	PPBLED	EQU P3.5
;;;;;;;;;;;;;;;;;;;;;
;; PROG help
;;
;;
;;	R5 - main loop
;;
;;	R0 - data byte for LCD
;;	R1 - commands for LCD
;;	
	


ORG 0x00
	LJMP MAIN
	

;#################################################
;Interrupts

; TODO: interrupts
; TODO: timers

ORG 03H ;external interrupt 0
RETI
ORG 0BH ;timer 0 interrupt
RETI
ORG 13H ;external interrupt 1
RETI
ORG 1BH ;timer 1 interrupt
RETI
ORG 23H ;serial port interrupt
RETI
ORG 25H ;locate beginning of rest of program



;#################################################
ORG 0x30 ;0x0A
;; test
DOTEST:
	MOV B, #0x40	; get start addr
	; write to RAM
	MOV R1, B		; set start address
	MOV @R1, #0x55	; write data
	INC R1			; next addr
	MOV @R1, #0x66	; write data
	; read from RAM
	MOV R1, B		; set start address
	MOV A, R1		; read addr
	MOV A, @R1		; read data
	INC R1
	MOV A, @R1		; read data
	RET

	
	

;;;
;;; 7-Segment LED test
;;;
DD_0 EQU 0b00111111
DD_1 EQU 0b00000110
DD_2 EQU 0b01011011
DD_3 EQU 0b01001111
DD_4 EQU 0b01100110
DD_5 EQU 0b01101101
DD_6 EQU 0b01111101
DD_7 EQU 0b00000111
DD_8 EQU 0b01111111
DD_9 EQU 0b01100111
SEG7LOOP:
	MOV A, #1
	ACALL DELAYS
	MOV P1, #DD_0
	
	MOV A, #1
	ACALL DELAYS
	MOV P1, #DD_1
	
	MOV A, #1
	ACALL DELAYS
	MOV P1, #DD_2
	
	MOV A, #1
	ACALL DELAYS
	MOV P1, #DD_3
	
	MOV A, #1
	ACALL DELAYS
	MOV P1, #DD_4
	
	MOV A, #1
	ACALL DELAYS
	MOV P1, #DD_5
	
	MOV A, #1
	ACALL DELAYS
	MOV P1, #DD_6
	
	MOV A, #1
	ACALL DELAYS
	MOV P1, #DD_7
	
	MOV A, #1
	ACALL DELAYS
	MOV P1, #DD_8
	
	MOV A, #1
	ACALL DELAYS
	MOV P1, #DD_9
		
	LJMP SEG7LOOP
	RET
	
	
	

;; INIT
INITIALIZE: ;set up control registers & ports
	MOV TCON, #0x00
	MOV TMOD, #0x00
	MOV PSW, #0x00 
	MOV IE, #0x00 ;disable interrupts
	RET

	
; =====================
;
; Точка входа
;
; =====================
MAIN:
	CLR PPLED
	CLR PPBLED
	;ACALL SEG7LOOP ;DOTEST
	ACALL INITIALIZE
	ACALL LCDINIT
	ACALL LCDCLEAR
	ACALL MAINLOOP
	
	
MAINLOOP:
	;ACALL LCDDRAW ; Draw once
	DONO:
		MOV R5, #10	; cycle
		;ACALL LCDDRAW - Do nothing
	
		DJNZ R5, DONO
	RET
	
	
; =====================
;
; Helpers
;
; =====================
; секунда
DELAYS:	; A = times
	MOV R7, A
	LMXZ:
		MOV R6, #4 ;#230
		LXZ:
		
			MOV R2, #250
			LMXD:
				MOV R3, #146 ;#230
				LXD:
					NOP
					NOP
					NOP
					NOP
					NOP
					NOP
					DJNZ R3, LXD
				DJNZ R2, LMXD
				
			DJNZ R6, LXZ
		DJNZ R7, LMXZ
	RET
; миллисекунда (10-3)
DELAYMS:	; A = times
	MOV R7, A
	LMX:
		MOV R6, #146 ;#230
		LX:
			NOP
			NOP
			NOP
			NOP
			NOP
			NOP
			DJNZ R6, LX
		DJNZ R7, LMX
	RET
; микросекунда (10-6)
DELAYNS:	; A = times
	MOV R7, A
	LMX3:
		MOV R6, #1 ;#230
		LX3:
			;NOP
			DJNZ R6, LX3
		DJNZ R7, LMX3
	RET
; наносекунда (10-9)
DELAYUS:	; A = times
	MOV R7, A
	LMX2:
		MOV R6, #2 ;#230
		LX2:
			NOP
			NOP
			NOP
			DJNZ R6, LX2
		DJNZ R7, LMX2
	RET

	
LIGHTBLUEON:
	SETB PPBLED
	MOV R7, #0x50
	LMX9:
		MOV R6, #230
		LX9:
			NOP
			NOP
			NOP
			NOP
			NOP
			NOP
			DJNZ R6, LX9
		DJNZ R7, LMX9
	CLR PPBLED
	RET
LIGHTBLUEOFF:
	CLR PPBLED
	RET
	
LIGHTGREEN:
	SETB PPLED
	MOV A, #0xFF
	MOV R7, A
	LMX22:
		MOV R6, #230
		LX22:
			NOP
			NOP
			NOP
			NOP
			NOP
			NOP
			DJNZ R6, LX22
		DJNZ R7, LMX22
	CLR PPLED
	RET
	
	
STEPEND:
	MOV P1, #0x00
	MOV P3, #0x00
	; GREEN
	ACALL LIGHTGREEN
	RET
	
; =====================
;
; Display
;
; =====================

; ----------------------	
; Инициализация дисплея
; ----------------------
LCDINIT:
	MOV A, #20
	ACALL DELAYMS
	;s_mtE(1)
	;s_mtRES(0)
	MOV P3, #0x01 ;#0b00000001 ;(E=1, RW=0, A0=0, CS=0, RES=0)
	;s_delayUs(12.0) #>10
	MOV A, #12
	ACALL DELAYUS
	;s_mtRES(1)
	SETB LCD_RES ;P3.4
	;s_delayMs(2.5)	#>1
	MOV A, #2
	ACALL DELAYMS
	; reset
	MOV R0, #0xE2
	ACALL LCDWRITE_CODE_L
	ACALL LCDWRITE_CODE_R
	; end (reset rmw)
	MOV R0, #0xEE
	ACALL LCDWRITE_CODE_L
	ACALL LCDWRITE_CODE_R
	; static off
	MOV R0, #0xA4
	ACALL LCDWRITE_CODE_L
	ACALL LCDWRITE_CODE_R
	; duty select
	MOV R0, #0xA9
	ACALL LCDWRITE_CODE_L
	ACALL LCDWRITE_CODE_R
	; display start line
	MOV R0, #0xC0
	ACALL LCDWRITE_CODE_L
	ACALL LCDWRITE_CODE_R
	;
	MOV R0, #0xA1
	ACALL LCDWRITE_CODE_L
	ACALL LCDWRITE_CODE_R
	; display on
	MOV R0, #0xAF
	ACALL LCDWRITE_CODE_L
	ACALL LCDWRITE_CODE_R
	
	; STEP END
	ACALL STEPEND
	RET


; ----------------------	
; Подача кода/команды в дисплей
; ----------------------
LCDWRITE:  ; R0(A) = data byte, R1 = cmd
	;s_writeByte(b, cd, lr)
	
	;s_mtRW(0) ;CLR P3.1
	;s_mtA0(cd)
	;s_mtCS(lr)
	; set E,RW,A0,CS
	MOV P3, R1
	;s_mtData(b)
	MOV P1, R0; A
	;s_delayNs(40.0)	#>40
	MOV A, #40
	ACALL DELAYNS
	;s_mtE(0)
	CLR LCD_E
	;s_delayNs(160.0)	#>160
	MOV A, #160
	ACALL DELAYNS
	;s_mtE(1)
	SETB LCD_E
	;s_delayNs(200.0 - 40.0 - 160.0) #2000.0 - 40.0 - 160.0
	MOV A, #10
	ACALL DELAYNS
	RET
LCDWRITE_CODE_L:	; R0 = data byte
	MOV R1, #0x09 ;#0b00001001 ;(E=1, RW=0, A0=0, CS=1)
	;MOV A, R0
	ACALL LCDWRITE
	RET
LCDWRITE_CODE_R:	; R0 = data byte
	MOV R1, #0x01 ;#0b00000001 ;(E=1, RW=0, A0=0, CS=0)
	;MOV A, R0
	ACALL LCDWRITE
	RET
LCDWRITE_DATA_L:	; R0 = data byte
	MOV R1, #0x0D ;#0b00001101 ;(E=1, RW=0, A0=1, CS=1)
	;MOV A, R0
	ACALL LCDWRITE
	RET
LCDWRITE_DATA_R:	; R0 = data byte
	MOV R1, #0x05 ;#0b00000101 ;(E=1, RW=0, A0=1, CS=0)
	;MOV A, R0
	ACALL LCDWRITE
	RET
	
	
; ----------------------	
; Очистка дисплея
; ----------------------
LCDCLEAR:
	MOV R4, #4	; page cycle
	LCDCLEAR_PAGE:
		; 4 to 0
		MOV A, #4
		SUBB A, R4
		MOV R2, A
		;; LEFT
		;s_writeCodeL(p|0xB8)
		MOV A, R2
		ORL A, #0xB8
		MOV R0, A
		ACALL LCDWRITE_CODE_L
		;s_writeCodeL(0x13)
		MOV R0, #0x13
		ACALL LCDWRITE_CODE_L
		; left draw
		MOV R0, #0x03 ; clear symbol 	!!!!! DEBUG !!!!! for 2pixel lines
		MOV R3, #61	; row cycle
		LCDCLEAR_PAGE_LEFT:
			MOV A, R3
			; DRAW 0x00
			;MOV R0, #0x00
			ACALL LCDWRITE_DATA_L
			DJNZ R3, LCDCLEAR_PAGE_LEFT
		;; RIGHT
		MOV A, R2
		ORL A, #0xB8
		MOV R0, A
		ACALL LCDWRITE_CODE_R
		MOV R0, #0x00
		ACALL LCDWRITE_CODE_R
		; right draw
		MOV R0, #0x03 ; clear symbol 	!!!!! DEBUG !!!!! for 2pixel lines
		MOV R3, #61	; row cycle
		LCDCLEAR_PAGE_RIGHT:
			MOV A, R3
			ADD A, #61
			; DRAW 0x00
			;MOV R0, #0x00
			ACALL LCDWRITE_DATA_R
			DJNZ R3, LCDCLEAR_PAGE_RIGHT
		
		DJNZ R4, LCDCLEAR_PAGE
	; STEP END
	ACALL STEPEND
	RET
	
; ----------------------	
; Рисуем в дисплей
; ----------------------
LCDDRAW:
	ACALL LCDCLEAR
	; TODO
	
	
	; JUST BEE !!!!!!!!!!!!!!1
	MOV R2, #0
	;; LEFT
	MOV A, R2
	ORL A, #0xB8
	MOV R0, A
	ACALL LCDWRITE_CODE_L
	MOV R0, #0x13
	ACALL LCDWRITE_CODE_L
	MOV R0, #0x99 ; symbol
	MOV R3, #61	; row cycle
	TMP_DRAW:
		MOV A, R3
		; DRAW 0x00
		;MOV R0, #0x00
		ACALL LCDWRITE_DATA_L
		DJNZ R3, TMP_DRAW

	
	
	
	
	RET





;#################################################
;##############    DATA   ########################
;#################################################

	DB 0x40

	;ORG 0x7F0 ; last bytes
	;DB 0x50, 0x88, 0x99


END

