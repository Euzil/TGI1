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
 INIT:	ser	Temp		; set PORT B 
	out	DDRB, Temp		; to output

	clr	Temp			; set PORT D
	out	DDRD, Temp		; to input
	out	PORTD, Temp 		; tri-state

	clr	Delay1			; set Delay1 to 0
	clr  	Delay2			; set Delay2 to 0 

; MAIN BLINK LOOP
 LOOP:	in	TempPo, PIND		; input PINs from PORT D
	andi	TempPo, 0b00000001 	; mask out Bit PD0
	breq	SKIP1			; skip next instruction if set to zero
	ldi	Temp, $FF		; else load pattern $FF

 SKIP1:	in	TempPo, PIND		; input PINs from PORT D
	andi	TempPo, 0b00000010 	; mask out Bit PD1
	breq	SKIP2			; skip next instruction if set to zero
	ldi	Temp, $55		; else load pattern $55

 SKIP2:	in	TempPo, PIND		; input PINs from PORT D
	andi	TempPo, 0b00000100 	; mask out Bit PD2
	breq	SKIP3			; skip next instruction if set to zero
	ldi	Temp, $0F		; else load pattern $0F

 SKIP3:	com	Temp			; complement LED value
	out	PORTB, Temp		; and put it on PORT B

; WAITING TIME
 DLY:	dec	Delay1			; inner waiting loop
	brne	DLY			; runs 256 times 3 cycles 
	dec	Delay2			; outer waiting loop
	brne	DLY			; runs inner loop 256 times

	break
	
	rjmp	LOOP			; go to next round