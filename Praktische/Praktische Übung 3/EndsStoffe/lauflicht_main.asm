; Bereitstellen der Namensdefinitionen wie DDRA, PORTA usw.
.nolist
.include "m16def.inc"
.list

; Hauptprogramm

                             ;  Definieren
 .def	Temp 	= R16
 .def   Delay   = R17
 .def   Delay1  = R20
 .def   Delay2  = R21
 .def   ONtime  = R22
 .def   Speed   = R24
                             ; Initiieren
INIT:	
                             ; setzt A,B und D als Ausgang
	ser	Temp	
    ser ONtime
	out	DDRD, Temp	         ; to output welche Lampe soll leuchten
	out	DDRA, Temp
    out DDRB, ONtime         ; to output wie lange Zeit soll stoppen         
    ldi Temp, high(RAMEND)
	out SPH, Temp
	ldi Temp, low(RAMEND)
	out SPL, Temp
    clr Temp
    out PortA, Temp
    out PortB, ONtime
    out PortD, Temp
	                         ; setzt PD4 und PD5 als Eingang
    ldi Temp, 0b11001111	 ; set PORT B 
    out DDRD, Temp
	ldi ONtime, $50          ; StoppeZeit initiiert zu $50 (80*10ms)
	ldi Speed, 5             ; Beschleunigung 5*10ms
    
   

main:
    out PORTB, ONtime        ; 7-Segement ausdrucken

;-------------------------------------------------------------------------------------------------------
    ldi	Temp, $1             ; fängt vom LampeRote_1 an 
	out	PORTA, Temp          ; output Pattern on PORT D

LOOP_1: 
                             ; Im PORTA geht es nur rote und gelbe Lampe
    out PORTB, ONtime

    mov Delay, ONtime        ; Setzt Dalay als Stoppezeit
	call WAIT                ; Im Waiting_Zeit
	lsl	Temp                 ; Links Lampe leuchten
	out	PORTA, Temp
    brne LOOP_1              ; if finish 
;--------------------------------------------------------------------------------------------------------
    ldi	Temp, $1             ; fängt vom Lampegrüne_1 an 
    out	PORTD, Temp	         ; output Pattern on PORT D

LOOP_2:
                             ; Im PORTD geht es nur Grüne Lampe
    out PORTB, ONtime

    mov Delay, ONtime        ; Setzt Dalay als Stoppezeit
	call WAIT                ; Im Waiting_Zeit
    lsl	Temp                 ; Links Lampe leuchten
	out	PORTD, Temp
	brne LOOP_2              ; if finish 
	break
;----------------------------------------------------------------------------------------------------------
jmp main                     ;zurück nach main und dann wider mal
  


	                         ;Wartenzeit
WAIT: 
 
       clr  Delay1	         ; init Delay1 with 0
       ldi  Delay2, 13	     ; init Delay2 with 13 (for 10 ms)---13*(255*3+2)Takte(ca.10ms)
 DLY:  dec  Delay1	         ; inner waiting loop
       brne DLY		         ; runs 256 times 3 cycles 
       dec  Delay2	         ; outer waiting loop
       brne DLY		         ; runs inner loop 256 times
       dec  Delay		     ; runs inner 2 loops Delay times
       brne WAIT		     ; if ready

       sbic PIND, PD4        ; Wenn PD4 nicht gedrückt werden, lauft nur skip
       add ONtime, Speed     ; Sonst vergrößern die Wartezeit

       sbic PIND, PD5        ; Wenn PD5 nicht gedrückt werden, lauft nur skip
       sub ONtime, Speed     ; Sonst verkleinern die Wartezeit

        out PORTB, ONtime
 ret		                 ; return

