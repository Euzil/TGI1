.nolist
.include "m16def.inc"
.list

; REGISTER DEFINITIONS
.def Temp = R16.                  ; Temporary Variable

.DSEG                             ; DATA SEGMENT
.ORG $0100                        ; Starting Addr in RAM
Q: .BYTE 5                        ; Reserve 5 bytes

.CSEG                             ; CODE SEGMENT
.ORG $0000                        ; Starting Addr. in ROM
INIT:	ldi	ZL, low(Q)  ; Init Z-Reg with
	ldi	ZH, high(Q) ; Addr of Q[0]
	ser	Temp        ; Set Temp Unterschied zu VL!!

ILOOP:	st	Z+, Temp    ; Store in Q, postinc Z
	cpi	ZL, low(Q+5); End of Q reached?
	brne	ILOOP       ; If not loop
	rjmp	INIT        ; Else done, endless loop
