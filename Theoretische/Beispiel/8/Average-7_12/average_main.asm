; AVERAGE
; Compute c=(a+b)/2
;  a = R16
;  b = R17
;  c = R18

.nolist
.include "m16def.inc"
.list

Main:	
	clr	R18		; init R18 with 0
	ldi	R16, 3	 	; load a into R16
	ldi	R17, 6	 	; load b into R17
	add	R18, R16	; add a to c
	add	R18, R17	; add b to c
	lsr	R18		; divide c by 2