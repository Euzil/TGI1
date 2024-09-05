; Bereitstellen der Namensdefinitionen wie DDRA, PORTA usw.
.nolist
.include "m16def.inc"
.list

.def goals = R22
.def tmp = R16
.def tmp2 = r17

.cseg
.org $000
RESET: jmp INIT

.org OVF0addr
    jmp CHECK4BALL_ISR

.org INT_VECTORS_SIZE

INIT:
    ldi tmp, high(RAMEND)
    out SPH, tmp
    ldi tmp, low(RAMEND)
    out SPL, tmp

    clr tmp
    out DDRA, tmp
    out PORTA, tmp

    out DDRB, tmp
    out PORTB, tmp

    out DDRC, tmp
    ldi tmp, 0b10000000 ; PC7 als Pullup
    out PORTC, tmp

    ser tmp
    out DDRD, tmp

    clr tmp
    out PORTD, tmp

    ldi tmp, (1<<CS02) | (1<<CS00) ; Prescaler 1024
    out TCCR0, tmp

    ldi tmp, (1<<TOIE0)    ; Overflow-Interrrupt
    out TIMSK, tmp

    sei ; globale Aktivierung der Interrupts

    jmp MAIN

; Hauptprogramm
MAIN:
    clr goals
ENDLESSLOOP:
    out PORTD, goals
    jmp ENDLESSLOOP

CHECK4BALL_ISR:
    push tmp
    in tmp, SREG
    push tmp

    in tmp, PINC
    sbrs tmp, PC6
    jmp  game_not_started
    jmp  game_started

game_not_started:
    clr goals
    jmp end_check4ball_isr

game_started:
    in tmp, PINA
    sbrs tmp, PA7 ; ist Wet >= 128, wenn ja -> dann zum Ende springen
    call check4freq

end_check4ball_isr:
    pop tmp
    out SREG, tmp
    pop tmp
    reti

check4freq:
    push tmp2
    push tmp

    in tmp, PINB
    andi tmp, 0b00001111 ; 0x0F

    in tmp2, PINC 
    andi tmp2, 0x0F

    cp tmp, tmp2
    brne end_check4freq 
    
    inc goals

wait4One:                       ; Fallende Flanke
    sbis PINC, PC7
    jmp wait4One

wait4Zero:
    sbic PINC, PC7
    jmp wait4Zero

end_check4freq:
    pop tmp
    pop tmp2
    ret

