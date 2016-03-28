

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
;		2 - 
;		3 - CS
;		4 - RES
;		5 - A0
;		7 -
;
; ++++++++++++++++++++++++++++++++++++++++++++++++++++
	LCD_E 	EQU P3.0

	LCD_RW 	EQU P3.1	; -- but not used directy in code
	LCD_CS	EQU P3.3	; -- but not used directy in code
	LCD_RES	EQU P3.4
	LCD_A0 	EQU P3.5	; -- but not used directy in code
	
	INT_BTN EQU P3.2	; out interrupt
	

;;;;;;;;;;;;;;;;;;;;;
;; PROG help
;;
;;
;;	R5 - main loop
;;
;;	R0 - data byte for LCD
;;	R1 - commands for LCD
;;	
	
	
	
; ++++++++++++++++++++++++++++++++++++++++++++++++++++
; constants
	GAME_FLAG_ADDR	EQU 0x40




ORG 0x00
	LJMP MAIN
	

;#################################################
; Прерывания
;#################################################


ORG 03H ;external interrupt 0 (вектор адреса поумолчанию)
	ACALL INT_BUTTON
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

	
	
	

;; INIT
; выключение прерываний (как правило на время инициализации)
DISINTS: ;set up control registers & ports
	MOV TCON, 	#0x00
	MOV TMOD, 	#0x00
	MOV PSW, 	#0x00 
	MOV IE, 	#0x00 ;disable interrupts
	RET

; button interrupt
INITBUTTONINT:
	SETB EA
	SETB EX0 ;=IE.0	; enable external interrupt 0
	;SETB INT_BTN
	RET
	
	
	
	
	
	

	
; =====================
;
; Точка входа
;
; =====================
MAIN:
	;ACALL SEG7LOOP ;DOTEST
	ACALL DISINTS
	ACALL LCDINIT
	
	MOV R1, #GAME_FLAG_ADDR		; set address
	MOV @R1, #0x00		; write data (GAME FLAG)
	MOV R1, #0x41		; set address
	MOV @R1, #0x00		; write data
	
	ACALL INITBUTTONINT
	ACALL MAINLOOP
	
	
MAINLOOP:
	ACALL LCDCLEAR
	;ACALL LCDDRAW ; Draw once

	DONO:
		MOV R5, #10	; cycle
		;ACALL LCDCLEAR
		ACALL LCDDRAW
	
		DJNZ R5, DONO
	RET
	
	
	
	
; =====================
; нажата кнопка (функция обработка прерывания)
INT_BUTTON:
	; save
	PUSH PSW
	PUSH ACC
	ACALL SETBANK2
	
	MOV R1, #GAME_FLAG_ADDR		; set address
	MOV A, @R1					; read data (GAME FLAG)
	INC A
	MOV @R1, A
	
	; A is GAMEFLAG data
	SETB P3.7
	;MOV A, #1
	;ACALL DELAYS
	CLR P3.7
	
	; restore
	ACALL SETBANK0
	POP ACC
	POP PSW
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

STEPEND:
	MOV P1, #0x00
	RET
	
SETBANK0:
	CLR PSW.3
	CLR PSW.4
	RET
SETBANK1:
	SETB PSW.3
	CLR PSW.4
	RET
SETBANK2:
	CLR PSW.3
	SETB PSW.4
	RET
SETBANK3:
	SETB PSW.3
	SETB PSW.4
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
	; pre wait
	;MOV A, #20
	;ACALL DELAYMS
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
LCDWRITE:  ; R0 = data byte, R1 = cmd
	; set E,RW,A0,CS
	; without fix RES
	MOV P3, R1
	
	; with fix RES (если неуверены, что во внешке оставили RES=1)
	;MOV A, R1
	;ORL A, #0x10	; RES forever 1
	;MOV P3, A; R1 - fixed R1
		
	;s_mtData(b)
	MOV P1, R0
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
	;MOV A, #10
	;ACALL DELAYNS
	RET
LCDWRITE_CODE_L:	; R0 = data byte
	;MOV R1, #0x19 ;#0b00011001 ;(E=1, RW=0, A0=0, CS=1, RES=1)
	MOV R1, #0x1D ;#0b00011101 ;(E=1, RW=0, INT0=1, CS=1, RES=1, A0=0)
	ACALL LCDWRITE
	RET
LCDWRITE_CODE_R:	; R0 = data byte
	;MOV R1, #0x11 ;#0b00010001 ;(E=1, RW=0, A0=0, CS=0, RES=1)
	MOV R1, #0x15 ;#0b00010101 ;(E=1, RW=0, INT0=1, CS=0, RES=1, A0=0)
	ACALL LCDWRITE
	RET
LCDWRITE_DATA_L:	; R0 = data byte
	;MOV R1, #0x1D ;#0b00011101 ;(E=1, RW=0, A0=1, CS=1, RES=1)
	MOV R1, #0x3D ;#0b00111101 ;(E=1, RW=0, INT0=1, CS=1, RES=1, A0=1)
	ACALL LCDWRITE
	RET
LCDWRITE_DATA_R:	; R0 = data byte
	;MOV R1, #0x15 ;#0b00010101 ;(E=1, RW=0, A0=1, CS=0, RES=1)
	MOV R1, #0x35 ;#0b00110101 ;(E=1, RW=0, INT0=1, CS=0, RES=1, A0=1)
	ACALL LCDWRITE
	RET
	
	
; ----------------------	
; Очистка дисплея
; ----------------------
LCDCLEAR:
	; reset addr
	MOV R0, #0xE2
	ACALL LCDWRITE_CODE_L
	
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
		MOV R0, #0x00 ; clear symbol
		MOV R3, #61	; row cycle
		LCDCLEAR_PAGE_LEFT:
			;MOV A, R3
			; DRAW 0x00
			;MOV R0, #0x00
			ACALL LCDWRITE_DATA_L
			DJNZ R3, LCDCLEAR_PAGE_LEFT
		;; RIGHT
		MOV A, R2
		ORL A, #0xB8
		MOV R0, A
		ACALL LCDWRITE_CODE_R
		MOV R0, #0x00 ;#0x00 #0x13  !!! WTF !!!
		ACALL LCDWRITE_CODE_R
		; right draw
		MOV R0, #0x00 ; clear symbol
		MOV R3, #61	; row cycle
		LCDCLEAR_PAGE_RIGHT:
			;MOV A, R3
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
	
	; reset addr
	;MOV R0, #0xE2
	;ACALL LCDWRITE_CODE_L
	;ACALL LCDWRITE_CODE_R
	

	
	
	
	; air
	ACALL DRAW_AIR
	
	; ground
	ACALL DRAW_GROUND
		
		
	; next frame
	;ACALL NEXT_OFFSET


		
	RET


; ----------------------	
; ----------------------	
; ----------------------	
	
; next offset
NEXT_OFFSET:
	; get air offset
	MOV R1, #0x40		; set start address
	MOV A, @R1			; read data
	; write next offset
	INC A
	; reset cycle
	CJNE A, #62, _dd_offset_1
	MOV A, #0
_dd_offset_1:
	;MOV R1, #0x40
	MOV @R1, A	; write data
	RET

;
; рисуем небо
;
DRAW_AIR:
	
	;; LEFT
	MOV R0, #0xE2		; reset addr
	ACALL LCDWRITE_CODE_L
	MOV R0, #0xB8		; page 0
	ACALL LCDWRITE_CODE_L
	MOV R0, #0x13		; addr
	ACALL LCDWRITE_CODE_L
			
	; get frame offset
	MOV R1, #0x40		; set start address
	MOV A, @R1			; read data
		
	; offset
	MOV DPTR, #0x600 	; start addrs of Air
	;MOV DPL, A			; set offset
	
	; draw
	MOV R2, #62
	PUSH ACC
	_DRSSn_4:
		;MOV A, #0
		POP ACC
		; reset cycle
		CJNE A, #16, _dd44_offset_1
		MOV A, #0
		_dd44_offset_1:
		
		PUSH ACC
		MOVC A, @A+DPTR
	
		; draw
		MOV R0, A
		ACALL LCDWRITE_DATA_L
		
		;INC DPTR
		POP ACC
		INC A
		PUSH ACC
		
		DJNZ R2, _DRSSn_4
	POP ACC
	
	
	; write offset
	MOV R1, #0x40		; set start address
	MOV @R1, A	; write data

	RET

;	
; рисуем землю
;
DRAW_GROUND:
	;; LEFT
	MOV R0, #0xE2		; reset addr
	ACALL LCDWRITE_CODE_L
	MOV R0, #0xBB		; page 3
	ACALL LCDWRITE_CODE_L
	MOV R0, #0x13		; addr
	ACALL LCDWRITE_CODE_L
			
	; get frame offset
	MOV R1, #0x41		; set start address
	MOV A, @R1			; read data
		
	; offset
	MOV DPTR, #0x620 	; start addrs of Air
	;MOV DPL, A			; set offset
	
	; draw
	MOV R2, #62
	PUSH ACC
	_DRSSn_42:
		;MOV A, #0
		POP ACC
		; reset cycle
		CJNE A, #16, _dd44_offset_12
		MOV A, #0
		_dd44_offset_12:
		
		PUSH ACC
		MOVC A, @A+DPTR
	
		; draw
		MOV R0, A
		ACALL LCDWRITE_DATA_L
		
		;INC DPTR
		POP ACC
		INC A
		PUSH ACC
		
		DJNZ R2, _DRSSn_42
	POP ACC
	
	; write offset
	MOV R1, #0x41
	MOV @R1, A
	
	
	
	
	RET
	
	
	
	
	
;#################################################
;#############    Draw helper   ##################
;#################################################

; вывод Символа (8x8 bit) в текущую позицию дисплея
DRSYMBL: ; DPTR = addr of symb
	;MOV DPTR, #0x600	
	MOV R2, #8 ; cols of 8 bytes (symbol) 
	_DRSS:
		MOV A, #0
		MOVC A, @A+DPTR
		MOV R0, A
		ACALL LCDWRITE_DATA_L
		INC DPTR
		DJNZ R2, _DRSS
	RET
DRSYMBR: ; DPTR = addr of symb
	;MOV DPTR, #0x600	
	MOV R2, #8 ; cols of 8 bytes (symbol) 
	_DRSS2:
		MOV A, #0
		MOVC A, @A+DPTR
		MOV R0, A
		ACALL LCDWRITE_DATA_R
		INC DPTR
		DJNZ R2, _DRSS2
	RET
	
DRSYMBNL: ; DPTR = addr of symb, A = count
	;MOV DPTR, #0x600	
	MOV R2, A ;#8 ; cols of 8 bytes (symbol) 
	_DRSSn:
		MOV A, #0
		MOVC A, @A+DPTR
		MOV R0, A
		ACALL LCDWRITE_DATA_L
		INC DPTR
		DJNZ R2, _DRSSn
	RET

;#################################################
;##############    DATA   ########################
;#################################################

;; air
ORG 0x600
	DB 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08
	DB 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10
;; ground
ORG 0x620
	DB 0xCF, 0x49, 0x79, 0x49, 0xCF, 0x49, 0x79, 0x49
	DB 0xCF, 0x49, 0x79, 0x49, 0xCF, 0x49, 0x79, 0x49
	
	
	
ORG 0x700
	DB 0x00, 0xff, 0xff, 0x03, 0x03, 0xff, 0xff, 0x00
	DB 0x00, 0xff, 0xff, 0x70, 0x0E, 0xff, 0xff, 0x00
	DB 0x00, 0xff, 0xff, 0xC3, 0xC3, 0xe7, 0xe7, 0x00
	DB 0x00, 0xcf, 0xef, 0x1d, 0x1d, 0xff, 0xff, 0x00

DATABR:
	DB 0x40



END

