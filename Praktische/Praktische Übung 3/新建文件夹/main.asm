;
; AssemblerApplication1.asm
;
; Created: 11.06.2019 14:53:11
; Author : TGI_7_12
;


; Replace with your application code

	.def		Temp		= R16
	.def		LEDlow		= R20
	.def		LEDhigh		= R21
	.def		Speed		= R22
	.def		Clow		= R23
	.def		Chigh		= R24
	.def		Delay1		= R18
	.def		Delay2		= R19
	.def		Cspeed		= R25

INIT:
	ldi			Temp, 0xFF
	out			DDRA, Temp
	out			DDRB, Temp
	ldi			Temp, 0x0F
	out			DDRD, Temp
	ldi			Temp, 0x00
	out			PORTD, Temp
	ldi			LEDlow, 1
	ldi			LEDhigh, 0
	ldi			Speed, 0x50
	out			PORTB, Speed
	clr			Delay1
	clr			Delay2
	clr			Clow
	clr			Chigh
	clr			Cspeed

MAIN:
  	mov			Cspeed, Speed
	andi		Clow, 0b10000000
	breq		SKIP1
	ldi			LEDlow, 0
	ldi			LEDhigh, 1
	mov			Clow, LEDlow
	mov			Chigh, LEDhigh
	out			PORTA, LEDlow
	out			PORTD, LEDhigh
	rjmp		DLS

SKIP1:
	andi		Chigh, 0b00001000
	breq		SHIFT
	ldi			LEDlow, 1
	ldi			LEDhigh, 0
	mov			Clow, LEDlow
	mov			Chigh, LEDhigh
	out			PORTA, LEDlow
	out			PORTD, LEDhigh
	rjmp		DLS

SHIFT:
	lsl			LEDlow
	mov			Clow, LEDlow
	lsl			LEDhigh
	mov			Chigh, LEDhigh
	out			PORTA, LEDlow
	out			PORTD, LEDhigh

DLS:
	ldi			Delay1, 170

DLY:
	dec			Delay1
	brne		DLY
;	dec			Delay2
;	brne		DLS
	dec			Cspeed
	brne		DLS
	
TASTEN:
	ldi			Temp, 5

	sbic		PIND, PD4
	sub			Speed, Temp

	sbic		PIND, PD5
	add			Speed, Temp
	out			PORTB, Speed

	rjmp		MAIN