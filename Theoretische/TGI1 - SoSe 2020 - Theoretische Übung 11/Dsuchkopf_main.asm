; Bereitstellen der Namensdefinitionen wie DDRA, PORTA usw.
.nolist
.include "m16def.inc"
.list


.def tmp = R16
.def tmp2 = R17
.def cnt = R22

.dseg
.org $0060
codes: .byte 9

.cseg
.org $00
RESET: jmp INIT

.org ADCCaddr
    jmp ADC_ISR

.org $30
ad_values: .db 23, 47, 71, 95, 119, 143, 167, 191, 255, 255

INIT:
    ldi tmp, high(RAMEND)
    out SPH, tmp
    ldi tmp, low(RAMEND)
    out SPL, tmp

    clr tmp
    out DDRA, tmp
    out PORTA, tmp

    ser tmp
    out DDRB, tmp
    out PORTB, tmp

    out DDRC, tmp
    
    clr tmp
    out PORTC, tmp

    ldi tmp, (1 << ADLAR) | (1 << REFS0)
    out ADMUX, tmp

    ldi tmp, (1 << ADEN) | (1 << ADPS2) | (1 << ADPS0) | (1 << ADIE)
    out ADCSRA, tmp

    sei

    break 

    call init_codes

    jmp main

init_codes:
    clr tmp
    ldi XH, high(codes)
    ldi XL, low(codes)
    st X+, tmp
ic_loop:
    lsl tmp
    inc tmp
    st X+, tmp
    cpi tmp, 255
    brne ic_loop
    ret

read_adc:
    ldi tmp, (1 << SM0) | (1 << SE)
    out MCUCR, tmp

    sbi ADCSRA, ADSC ; NUR IM SIMULATOR

    SLEEP

    in R16, ADCH
    ret

ADC_ISR:
    push tmp
    in tmp, SREG
    push tmp

    ldi tmp, (1 << SM0) ; kann hier auch alles auf 0 setzen
    out MCUCR, tmp

    pop tmp
    out SREG, tmp
    pop tmp
    reti

; Hauptprogramm
main:
    ; Hier kommt ihr Assembler-Code hin
    sbic PINA, PA1
    jmp water

no_water:
    clr tmp
    out PORTB, tmp
    out PORTC, tmp
    jmp main

water:
    call read_adc
    ; hier in tmp=R16 das Ergebnis der AD-Wandlung 

    clr cnt
    ldi ZH, high(ad_values << 1)
    ldi ZL, low(ad_values << 1)

cmp_loop:
    lpm tmp2, Z+
    inc tmp2
    cp tmp, tmp2 
    brcs leds
    cpi tmp2, 0
    breq leds

    inc cnt
    jmp cmp_loop  

leds:
    ldi YH, high(codes)
    ldi YL, low(codes)
    add YL, cnt ; weil YL < 0x69
    
    ld tmp2, Y
    out PORTC, tmp2
    com tmp2
    out PORTB, tmp2

    jmp main
