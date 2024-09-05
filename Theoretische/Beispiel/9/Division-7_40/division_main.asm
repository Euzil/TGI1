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

; LOAD PARAMETERS & CALL DIV
MAIN:  ldi  a, 10     ; load Dividend 
       ldi  b, 3      ; load Divisor
       call DIV	       ; call DIV subroutine
ENDLESSLOOP:
		rjmp ENDLESSLOOP      ; goto next round

; DIVISION SUBROUTINE
; computes a : b = q Rem r
DIV:	mov	r, a	; set remainder to Dividend
	clr	q	; clear Quotient

LOOP:	cp	r, b	; check, if sub of Divisor is possible
	brcs	DONE	; if not, goto DONE
	sub	r, b	; else subtract Divisor
	inc	q	; and increment Quotient 
	rjmp	LOOP	; Next subtraction Loop

DONE:	ret		; Return to Calling Program