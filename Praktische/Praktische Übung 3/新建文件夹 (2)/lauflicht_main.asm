; Bereitstellen der Namensdefinitionen wie DDRA, PORTA usw.
.nolist
.include "m16def.inc"
.list

.def Temp = r16
.def LEDlow = r20
.def LEDhigh =  r21
.def Speed = r22
.def Speed1 = r23
.def SpeedBackup = r24
.def IncStep = r25
Init:
ser Temp
out DDRA, Temp
out DDRB, Temp ;Setzt DDR A,B,D als Ausgang
ldi Temp, 0b11001111
out DDRD, Temp ;Setzt PD 4,5 als Eingang
clr Temp
out PortA, Temp
out PortB, Temp
out PortD, Temp
ser LEDlow
clr LEDhigh
ldi Speed, 0x50
ldi Speed1, 0x00
mov SpeedBackup, Speed
ldi IncStep, 0x05

; Hauptprogramm
main:
    
ldi Temp, 0b00000001
out PORTA, Temp
call dly
lsl temp
out PORTA, Temp
call dly
lsl temp
out PORTA, Temp
call dly
lsl temp
out PORTA, Temp
call dly
lsl temp
out PORTA, Temp
call dly
lsl temp
out PORTA, Temp
call dly
lsl temp
out PORTA, Temp
call dly
lsl temp
out PORTA, Temp
call dly
out PORTA, LEDHigh
ldi Temp, 0b00000001
out PORTD, Temp
call dly
lsl temp
out PORTD, Temp
call dly
lsl temp
out PORTD, Temp
call dly
lsl temp
out PORTD, Temp
call dly
out PORTD, LEDhigh
jmp main

dly:

dec Speed
brne dly
mov Speed, SpeedBackup
dec Speed1
brne dly

sbic PIND, PD4
add SpeedBackup, IncStep

sbic PIND, PD5
sub SpeedBackup, IncStep

out PORTB, speed
RET