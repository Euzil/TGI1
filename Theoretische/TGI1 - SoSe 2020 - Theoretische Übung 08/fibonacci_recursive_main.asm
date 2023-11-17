; Bereitstellen der Namensdefinitionen wie DDRA, PORTA usw.
.nolist
.include "m16def.inc"
.list

.def prev = r17
.def preprev = r18
.def k = r19
.def result = r20
.def tmp = r21

init:
    ldi tmp, low(RAMEND)
    out SPL, tmp
    ldi tmp, high(RAMEND)
    out SPH, tmp

; Hauptprogramm
main:
    ldi prev, 1 ; f(1) -> Initalwert
    ldi preprev, 0 ; f(0) -> Initalwert
    ldi k, 4 ; wir wollen die k-te Fibonaccizahl berechnen

    call fib ; Aufruf des UP

end:
    jmp end

; Unterprogramm
fib:
    push K
    push prev
    push preprev
    push tmp
    in tmp, SREG
    push tmp

    cpi k, 0         ; sind wir schon fertig? <- Interrrupt  
    breq cp_result      

    dec k           ; dekrementiere k
    mov tmp, prev   ; Sicherumg des Vorgaengers, der der neu Vorvorgaenger werden muss
    add prev, preprev ; Berechnung des neuen Vorgaengers
    mov preprev, tmp  ; Kopieren des gesicherten Wertes in das Reister des Vorvorgängers

    call fib    ; weiter zur naechsten Runde
    jmp fib_end

cp_result:
    mov result, preprev ; Kopieren des Ergebnisses in das result-Registers
fib_end:
    pop tmp
    out SREG, tmp
    pop tmp
    pop tmp
    pop preprev
    pop prev
    pop k

    ret ; Ruecksprung