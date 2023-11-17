.nolist
.include "m16def.inc"
.list

;  BLINKY
;  Blinking LEDs on PORT B (all 8 together)

; DEFINE REGISTERS 
  .def	Temp 	= R16
  .def	Delay1 	= R17
  .def	Delay2	= R18

; INITIALIZE PORTS AND REGISTERS
INIT:	ser	Temp		; set PORT B 
	out	DDRB, Temp	; to output
	clr	Delay1		; set Delay1 to 0
	clr	Delay2		; set Delay2 to 0 
	ldi	Temp, $55	; init Temp with Pattern

; MAIN BLINK LOOP
LOOP:	com	Temp		; complement Pattern
	out	PORTB, Temp	; output Pattern on PORT B	

; WAITING TIME
 DLY:	dec	Delay1		; inner waiting loop
	brne	DLY		; runs 256 times 3 cycles 
	dec	Delay2		; outer waiting loop
	brne	DLY		; runs inner loop 256 times

	break

	rjmp	LOOP		; go to next round
