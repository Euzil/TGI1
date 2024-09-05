.nolist
.include "m16def.inc"
.list

; DIV-Formula
; Use of DIV Subroutine to compute the formula
;                               W = U:V + S:T	
; U, V, S, T as Constants in Program Memory
; Result W as Variable in Data Memory				
; DEFINE REGISTERS
.def	a= R20		; Dividend
.def	b= R21		; Divisor
.def	q= R22		; Quotient
.def	r= R23		; Remainder
.def	Temp = R16	; Temporary Register


; INIT STACK POINTER & Z-REG FOR TABLE
INIT:	ldi		Temp, high(RAMEND)	; init
		out		SPH, Temp		; Stackptr
		ldi		Temp, low(RAMEND)	; to end
		out		SPL, Temp		; of RAM

		ldi		ZH, high(TAB<<1)		; init Z-Reg to
		ldi		ZL, low(TAB<<1)		; TAB (Byte Address!)

	; COMPUTE  W = U:V + S:T WITH DIV ROUTINE
MAIN:	lpm		a, Z+	; load Dividend with U 
		lpm		b, Z+	; load Divisor with V
		call	DIV	; call DIV routine
		mov		Temp, q	; save Quotient U:V
		lpm		a, Z+	; load Dividend with S
		lpm		b, Z	; load Divisor with T
		call	DIV	; call DIV routine
		add		Temp, q	; add quotient S:T to U:V
		sts		W, Temp	; store result under W in DMEM  
		rjmp	end	; goto next round

		end:
		rjmp end

		; DIVISION SUBROUTINE
; computes a : b = q Rem r
DIV:	mov		r, a	; set remainder to Dividend
		clr		q	; clear Quotient

LOOP:	cp		r, b	; check, if sub of Divisor is possible
		brcs	DONE	; if not, goto DONE
		sub		r, b	; else subtract Divisor
		inc		q	; and increment Quotient 
		rjmp	LOOP	; Next subtraction Loop

DONE:	ret		; Return to Calling Program



; INPUT DATA  AS TABLE IN PMEM (U, V, S, T)
.ORG	$0100                      ; word address
TAB:    	.DB  16, 7, 9, 3      	; Define Bytes U, V, S, T under Label TAB

; RESULT W IN DMEM
.DSEG
.ORG	$0100                      ; byte address
W:	.BYTE 1		; Reserve 1 Byte under Label W