; Bereitstellen der Namensdefinitionen wie DDRA, PORTA usw.
.nolist
.include "m16def.inc"
.list

.def tmp = r16
.def v1 = r17
.def v2 = r18
.def hamming = r19

Init:
    ; Konfiguration PORTD
    ldi tmp, 0b11111111
    out DDRD, tmp

    ; Ausgabe auf PORTD -> keine LED leuchtet 
    ldi tmp, 0b00000000
    out PORTD, tmp 

    ; Konf. PORTA und PORTB
    clr tmp
    out DDRA, tmp
    out DDRB, tmp

    out PORTA, tmp
    out PORTB, tmp

; Hauptprogramm
main:
    ; Hier kommt ihr Assembler-Code hin
    in v1, PINA ; einlesen Wert 1
    in v2, PINB ; einlesen Wert 2

    eor v1, v2 ; xor

    clr hamming
loop:
    tst v1 ; cpi v1, 0
    breq led
    lsl v1
    brcs inkrementieren
    jmp loop 

inkrementieren:
    inc hamming
    jmp loop    

led:
    clr tmp
led_loop:
    tst hamming
    breq end
    lsl tmp          
    inc tmp
    dec hamming
    jmp led_loop

end:
    out PORTD, tmp
    jmp main