; Bereitstellen der Namensdefinitionen wie DDRA, PORTA usw.
.nolist
.include "m16def.inc"
.list

; Hauptprogramm
 .def	Temp 	= R16
 .def   Delay   = R17
 .def   Delay1  = R20
 .def   Delay2  = R21
 .def   ONtime  = R22
 .def   Speed   = R24
 
INIT:	
	ser	Temp	
    ser ONtime
	out	DDRD, Temp	; to output
	out	DDRA, Temp
    out DDRB, ONtime
    ldi Temp, high(RAMEND)
	out SPH, Temp
	ldi Temp, low(RAMEND)
	out SPL, Temp
    clr Temp
    out PortA, Temp
    out PortB, ONtime
    out PortD, Temp


    ldi Temp, 0b11001111	; set PORT B 
    out DDRD, Temp
	ldi ONtime, $50
	ldi Speed, 5 
    
   

main:


    out PORTB, ONtime
   
    ldi	Temp, $8
    out	PORTD, Temp	; output Pattern on PORT B	
    
LOOP_1: 

    out PORTB, ONtime

    mov Delay, ONtime
	call WAIT
    lsr	Temp
	out	PORTD, Temp
	brne LOOP_1
	break
    


    ldi	Temp, $80
	out	PORTA, Temp
	
LOOP_2:
   
    out PORTB, ONtime

    mov Delay, ONtime
	call WAIT
	lsr	Temp
	out	PORTA, Temp
    brne LOOP_2

jmp main
  

    ; Hier kommt ihr Assembler-Code hin

    ;Lauflicht Beschriebung


	;Waiting Zeit
WAIT: 

 
       
       clr  Delay1	; init Delay1 with 0
       ldi  Delay2, 13	; init Delay2 with 13 (for 10 ms)
 DLY:  dec  Delay1	; inner waiting loop
       brne DLY		; runs 256 times 3 cycles 
       dec  Delay2	; outer waiting loop
       brne DLY		; runs inner loop 256 times
       dec  Delay		; runs inner 2 loops Delay times
       brne WAIT		; if ready

        sbic PIND, PD4
        add ONtime, Speed

        sbic PIND, PD5
        sub ONtime, Speed

        out PORTB, ONtime
 ret		; return

