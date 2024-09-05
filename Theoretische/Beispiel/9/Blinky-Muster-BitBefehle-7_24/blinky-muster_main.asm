.nolist
.include "m16def.inc"
.list

; BLINK
; Blinking LEDS on PORT B in various patterns
; depending on which switch is pressed on PORT D:
; PD0: $FF
; PD1: $55
; PD2: $0F


; DEFINE REGISTERS 
 .def	Temp	= R16
 .def	TempPo	= R19
 .def	Delay1	= R17
 .def	Delay2	= R18


 ; INITIALIZE PORTS AND REGISTERS
 INIT:	ser	Temp	; set PORT B 
	out	DDRB, Temp	; to output

	clr	Temp		; set PORT D
	out	DDRD, Temp	; to input
	out	PORTD, Temp 	; tri-state

	clr	Delay1		; set Delay1 to 0
	clr  	Delay2		; set Delay2 to 0 

; MAIN BLINK LOOP
  LOOP:	sbic	PIND, PD0	; skip if PD0 is not pressed
	ldi	Temp, $FF	; else set pattern to $FF

	sbic	PIND, PD1	; skip if PD1 is not pressed
	ldi	Temp, $55	; else set pattern to $55

	sbic	PIND, PD2	; skip if PD2 is not pressed
	ldi	Temp, $0F	; else set pattern to $0F

	com	Temp		; complement LED value
	out	PORTB, Temp	; and put it on PORT B

; WAITING TIME
 DLY:	dec	Delay1		; inner waiting loop
	brne	DLY		; runs 256 times 3 cycles 
	dec	Delay2		; outer waiting loop
	brne	DLY		; runs inner loop 256 times

	break
	
	rjmp	LOOP		; go to next round

