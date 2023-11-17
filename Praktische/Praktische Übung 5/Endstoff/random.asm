;
; random.asm
;
;  Created: 05.01.2015 10:57:44
;   Author: User
;
; Angepasster Zufallsgenerator aus dem vorherigen TGI Versuch 12
;

.cseg
; =======================================
;       VORGEGEBENE UNTERPROGRAMME
; =======================================
; =======================================

; LFSR
; --------
; Linear rueckgekoppeltes Schieberegister
; Verwendet fuer das Fibonacci-LFSR das Generatorpolynom x^8+x^6+x^5+x^4+1
; Gibt eine Zufallszahl zwischen 11 und 15 zurueck
; I: Erwartet in der Variablen "seed" einen Seed bzw. den alten Schieberegisterwert
; O: R16: Zufallszahl
rand:
	push	R15						; Register sichern
	push	R17

	clr		R17
	lds		R16, SEED
	sbrc	R16, 7					; Bit x^8
	inc		R17
	sbrc	R16, 5					; bIt x^6
	inc		R17
	sbrc	R16, 4					; bIt x^5
	inc		R17
	sbrc	R16, 3					; Bit x^4
	inc		R17
	inc		R17						; +1
	andi	R17, 1					; Bitmaske mit 1
	lsl		R16						; shifte alten Wert nach links
	or		R16, R17				; und addiere Wert aus Polynom drauf
	sts		SEED, R16				; speichere Wert wieder ab.

	lds		R17, DIVISOR			; lade Divisor in R17
	call 	div8u					; und berechne R15 = R16/12
	mov		R16, R15				; schreibe das Ergebnis in R16 zurueck

	pop		R17						; Register wieder herstellen
	pop		R15
	ret


; DIV8U
; ----------
; 8/8 Division (unsigned)
; I: R16: Dividend, R17: Divisor
; O: R16: Ergebnis, R15: Rest
div8u:
	push	R18
	clr		r15			;clear remainder and carry
	ldi		r18,9		;init loop counter
d8u_1:
	rol		r16			;shift left dividend
	dec		r18			;decrement counter
	brne	d8u_2		;if done
	pop		R18
	ret					;return
d8u_2:
	rol		r15			;shift dividend into remainder
	sub		r15,r17		;remainder = remainder - divisor
	brcc	d8u_3		;if result negative
	add		r15,r17		;restore remainder
	clc					;clear carry to be shifted into result
	rjmp	d8u_1		;else
d8u_3:
	sec					;set carry to be shifted into result
	rjmp	d8u_1