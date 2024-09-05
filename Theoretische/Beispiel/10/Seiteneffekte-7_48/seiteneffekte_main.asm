.nolist
.include "m16def.inc"
.list

;  FLASHY                                    
;  Flashing LEDs on PORT B (all 8 together)   
 ; DEFINE REGISTERS AND CONSTANTS 
 .def Temp    = R16
 .def Delay   = R17
 .equ Pattern = $55 
 .equ OnTime  = 10
 .equ OffTime = 50

; INITIALIZE PORT & STACK POINTER
INIT: ser Temp			; set PORT B 
      out DDRB, Temp		; to output
      ldi Temp, high(RAMEND)	; init
      out SPH, Temp		; Stackptr
      ldi Temp, low(RAMEND)	; to end
      out SPL, Temp		; of RAM

; MAIN FLASH LOOP
 LOOP: ldi  Temp, Pattern		; init Temp with Pattern
       out  PORTB, Temp		; output Pattern on PORT B
       ldi  Delay, OnTime		; set On-Time 
       break
       call WAIT			; and wait
Back1: clr  Temp			; Set Temp to 0
       out  PORTB, Temp		; output 0 on PORT B
       ldi  Delay, OffTime	; set Off-Time
       break
       call WAIT			; and wait

Back2: rjmp LOOP		; go to next round

; WAITING TIME - SAVE VERSION
; Input: Delay in multiples of 10 ms
.def Delay1 = R20
.def Delay2 = R21
WAIT:  push Delay		; save Delay on Stack
       push Delay1	; save Delay1 on Stack
       push Delay2	; save Delay2 on Stack
DLOOP: clr  Delay1	; init Delay1 with 0
       ldi  Delay2, 13	; init Delay2 with 13 (for 10 ms)
DLY:   dec  Delay1	; inner waiting loop
       brne DLY		; runs 256 times 3 cycles 
       dec  Delay2	; outer waiting loop
       brne DLY		; runs inner loop 256 times
       dec  Delay		; runs inner 2 loops Delay times
       brne DLOOP		; if ready
       break
       pop  Delay2	; restore Delay2 from Stack
       pop  Delay1	; restore Delay1 from Stack
       pop  Delay		; restore Delay from Stack
       ret		; return