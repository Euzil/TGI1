;Erstellt von Steffen Haeusler & Christoph Cohrs-Thiede
; Bereitstellen der Namensdefinitionen wie DDRA, PORTA usw.
.nolist
.include "m16def.inc"
.list
.def temp = r16
.def low = r17
.def high = r18
.def digit = r20
.def falsch = r21
.def count = r19
.def Lampe = r22
.def temp2 = r23

                       ; Legt richtige Kennwort im ROM ab
.ORG $0100
TAB: .DB 0, 8, 1, 5

                       ; initialisieren
init:
clr low
ser high
clr falsch
out DDRB, high
out DDRD, high
ldi temp, 0b01111110
out DDRA, temp  
ldi Temp, high(RAMEND)	    
out SPH, Temp		         
ldi Temp, low(RAMEND)	     
out SPL, Temp		         

main:
ldi ZH, high(TAB<<1)   
ldi ZL, low(TAB<<1)
out PORTB, low
clr digit              ; 7-Segement ersetzen
clr falsch
ldi count, 4           ; Insgesamt 4 Position

;---------------------------------------------------------------------------------------------------------------------------------------
ldi Lampe, 0b00001000  ; fängt vom PB3 an
                       ; Läuft ab, bis alle Zahlen eingegeben sind
loop:
out PORTB, Lampe       ; welche Lampe soll leuchten
mov temp, Lampe
lsr Lampe              ; um die nächste Lampe ersetzen(jeder Lampe bedeutet eine Position des Kennwort)
or Lampe, temp         ; alle Lampe sollen auch leuchten
call poll_buttons      ; eingeben die Kennwort durch button 
lpm temp, Z+           ; Ersetzen die Soll-Zahl auf dem Temp
cpse digit, temp       ; vergleichen dem Digit und Soll-Zahl
ser falsch               ; Wenn ungleich(falsch) ist, setzt fail 1 
dec count              ; count - 1 
brne loop

                       ; Wenn Eingabe falsch ist
ldi temp, 0b00100000   ; setzt dem Lampe
cpse falsch, low         ; überprüfen, ob das fail 0 
out PORTB ,temp        ; Rote Lampe

                       ; Wenn Eingabe falsch ist    
ldi temp, 0b00010000   ; setzt dem Lampe
cpse falsch, high        ; überprüfen, ob das fail 0
out PORTB, temp        ; grüne Lampe
call poll_buttons

jmp main

poll_buttons:
push temp              ; in Stack
push temp2             ; in Stack
clr digit
clr temp
clr temp2

poll_loop:
                        ; Ermittelt, ob PA7 low ist
sbis PINA, PA7          ; Wenn PA7 gerückt wurde 
call A7                 ; dann laufen A7 nicht (skip)
                        ; Ermittelt, ob PA7 gedrueckt wurde
sbis PINA, PA7          ; Wenn PA7 gerückt wurde
clr temp                ; setzt temp nicht zum 0 (skip)
sbic PINA, PA7          ; Wenn PA7 gerückt wurde  (Hier ist der echt Weg zum A7 rufen)
ser temp                ; setzt temp zum 1 

                        ; Setzt Digit zurueck
cpi digit, 10           ; Wenn eingabe vermisst, dann kann man noch mal eingeben
breq reset              ; reset zum 0 
out PORTD, digit
                        ; Ermittelt, ob PA0 low ist
sbis PINA, PA0          ; Wenn PA0 gerückt wurde 
jmp A0                  ; dann nicht zum A0

poll_loop_2:
                        ; Ermittelt, ob PA0 gedrueckt wurde
sbis PINA, PA0          ; Wenn PA0 gerückt wurde 
clr temp2               ; setzt temp2 nicht zum 0 (skip)
sbic PINA, PA0          ; Wenn PA0 gerückt wurde  (Hier ist der echt Weg zum A0 rufen)
ser temp2               ; setzt temp2 zum 1 
jmp poll_loop

Done:
pop temp2               ; Out Stack
pop temp                ; Out Stack (FILO)
RET

reset:
break
clr digit               ; digit zum 0
out PORTD, digit        ; 7-Segement ausdrucken
jmp poll_loop

A7:
cpse temp, low          ; überprüfen, ob temp 0 ist. (Es lauft viel mal durch. Aber niemals zum inc laufen, weil temp immer 0 ist. Bis einmal PA7 drücken und temp wird zum 1 gesetzt, dann kann inc laufen)
inc digit               ; Wenn Ja ist , dann skip . Wenn nein ist, digit +1
clr temp      
RET

A0:
cpse temp2, low         ; überprüfen, ob temp2 0 ist. (Es lauft viel mal durch. Aber niemals zum jmp laufen, weil temp2 immer 0 ist. Bis einmal PA7 drücken und temp2 wird zum 1 gesetzt, dann kann jmp laufen)
jmp Done                ; Wenn Ja ist , dann skip . Wenn nein ist, laufen Done.
clr temp2
jmp poll_loop_2

