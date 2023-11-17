; Bereitstellen der Namensdefinitionen wie DDRA, PORTA usw.
.nolist
.include "m16def.inc"
.list

.equ arraylength = 10

.def tmp = r16
.def length = r18
.def oCount = r19
.def iCount = r20
.def elem1 = r21
.def elem2 = r22

.dseg           ; Wechsel ins Datensegment (RAM)
.org $60        ; Gehen an Adresse 0x60
ARRAY: .byte arraylength    ; Reserviere 10 Bytes
; ARRAY2: .byte 3 ; Adresse $6A

.cseg           ; Wechsel ins Codesegment (ROM)
.org $00        ; Gehen an Adresse 0

init: 
    ldi tmp, high(RAMEND)
    out SPH, tmp
    ldi tmp, low(RAMEND)
    out SPL, tmp

; Hauptprogramm
main:
    ; Z-Register zeigt auf Anfang der Daten im ROM
    ldi ZH, high(NUMBERS << 1) ; Adresse der Daten mal 2 (wegen lpm)
    ldi ZL, low(NUMBERS * 2)

    ; X-Register zeigt auf Anfang des reservierten Speicherbereichs im RAM
    ldi XH, high(ARRAY)
    ldi XL, low(ARRAY)
    
    clr tmp     ; Counter für die Schleife
cploop:
    lpm R17, Z+ ; hole den Wert aus dem ROM
    st X+, R17  ; speichere den Wert im RAM

    inc tmp
    cpi tmp, arraylength
    brne cploop

    break

    ; sortieren mit Unterprogramm 
    ldi YH, high(ARRAY)
    ldi YL, low(ARRAY)
    ldi length, arraylength

    call bubblesort
end:
    jmp end

bubblesort:

    mov oCount, length  ; Initialisierung meiner aeusseren Schleife
    dec oCount
OLOOP:
    clr iCount  ; Initialisierung innere Schleife
    mov XH, YH  ; X-Register zeigt auf den Anfang des Arrays
    mov XL, YL
ILOOP:
    ld elem1, X+
    ld elem2, X

    cp elem1, elem2         ; Sortierung aufsteigend 
    brcs INEXT              ; elem2 > elem1 -> nicht tauschen

    dec XL
    st X+, elem2
    st X, elem1

INEXT:
    inc iCount
    cp iCount, oCount
    brne ILOOP

ONEXT:
    dec oCount
    tst oCount
    brne OLOOP

    ret

NUMBERS: .db 6, 4, 8, 9, 200, 155, 100, 255, 43, 41