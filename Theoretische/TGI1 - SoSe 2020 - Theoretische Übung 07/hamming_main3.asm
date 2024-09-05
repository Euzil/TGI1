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
    cpi v1, 0 
    breq led ; wenn keine 1 mehr in v1 -> fertig

    mov tmp, v1 
    lsr v1

    andi tmp, 1 ; alle Bits auf Bit 0 löschen, wenn Bit0 = 1 dann steht in tmp 1

    cpi tmp, 1 ; ist tmp 1?
    brne loop  ; wenn nicht, dann nicht inkrementieren
    inc hamming ; inkrementiern der Hammingdistanz
    jmp loop   ; Springen zur nächsten Runde

led:
    clr tmp
led_loop:
    tst hamming ; Wenn die Hammingdistanz 0 ist, bin ich fertig und muss keine zusaetzliceh Lampe mehr anschalten
    breq end
    lsl tmp ; Shiften aller bisher eingeschalteten LEDs nach links
    inc tmp ; Einschlaten der unteren LED (also Stezen des Bits, das spaeter die LED einschaltet)        
    dec hamming ; Reduzieren der Hammingdistanz
    jmp led_loop ; naechste Runde

end:
    out PORTD, tmp ; Einschalten der LEDs für die in Tmp eine 1 steht
    jmp main