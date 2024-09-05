; Bereitstellen der Namensdefinitionen wie DDRA, PORTA usw.
.nolist
.include "m16def.inc"
.list

.def prev = r17
.def preprev = r18
.def k = r19
.def result = r20
.def tmp = r21


; Hauptprogramm
main:
    ldi prev, 1 ; f(2) -> Initalwert
    ldi preprev, 1 ; f(1) -> Initalwert
    ldi k, 4 ; wir wollen die k-te Fibinaccizahl berechnen

fib_loop:
    cpi k, 1         ; sind wir schon fertig? 
    breq cp_result      

    dec k           ; dekrementiere k
    mov tmp, prev   ; Sicherumg des Vorgaengers, der der neu Vorvorgaenger werden muss
    add prev, preprev ; Berechnung des neune Vorgaengers
    mov preprev, tmp  ; Kopieren des gesicherten Wertes in das Reister des Vorvorgängers

    jmp fib_loop    ; weiter zur naechsten Runde

cp_result:
    mov result, preprev ; Kopieren des Ergebnisses in das result-Registers
end:
    jmp end