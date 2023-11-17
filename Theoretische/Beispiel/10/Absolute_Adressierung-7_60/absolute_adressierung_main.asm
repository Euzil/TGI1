.nolist
.include "m16def.inc"
.list

;REGISTER DEFINITIONS
.def Temp = R16			  ; Temporary Variable

.DSEG  				  ; DATA SEGMENT
.ORG $0100		  		  ; Starting Adr in RAM
Q: .BYTE 5	  			  ; Reserve 5 bytes

.CSEG				  ; CODE SEGMENT
.ORG $0000				  ; Starting Adr. in ROM
START:	ser	Temp		  ; Set TEMP Unterschied zu VL!!
	sts	Q, Temp	  ; Set Q[0] to zero
	sts	Q+1, Temp	  ; Set Q[1] to zero
	sts	Q+2, Temp	  ; Set Q[2] to zero
	sts	Q+3, Temp	  ; Set Q[3] to zero
	sts	Q+4, Temp	  ; Set Q[4] to zero
LOOP:	
	rjmp	LOOP		  ; done, endless loop
