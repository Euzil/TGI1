;
; SpaceInvaders.asm
;
;  Created: 15.12.2014 14:20:23
;   Author: Ehlers
;

.nolist
.include "m16def.inc"
.list

.dseg                               ; Data Segment
                                    ; SRAM - Der Speicher des Controllers(statisches RAM)
									; STS--Legt den in einem Register gespeicherten Wert in einer SRAM-Speicherzelle ab
									; LDS--Liest die angegebene SRAM-Speicherzelle und legt den gelesenen Wert in einem Register ab.
.org $060
                                    ; Munition
AMMO: .byte 1                       ; 1 Byte unter dem Namen 'AMMO' reservieren
                                    ; Abgelaufene Zeit
TIME: .byte 1                       ; 1 Byte unter dem Namen 'TIME' reservieren
                                    ; Erreichte Punkte
POINTS: .byte 1                     ; 1 Byte unter dem Namen 'POINTS' reservieren
                                    ; Alien Spezies [4,7]
ALIEN_SPECIES: .byte 1              ; 1 Byte unter dem Namen 'ALIEN_SPECIES' reservieren
                                    ; Alien Position auf dem Display in der oberen [0-13]
ALIEN_POSITION: .byte 1             ; 1 Byte unter dem Namen 'ALIEN_POSITION' reservieren
                                    ; Raumschiff Position auf dem Displayin in der unteren Zeile [0-13]
SPACESHIP_POSITION: .byte 1         ; 1 Byte unter dem Namen 'SPACESHIP_POSITION' reservieren
                                    ; Symbol des Raumschiffs
SPACESHIP: .byte 1                  ; 1 Byte unter dem Namen 'SPACESHIP' reservieren
                                    ; Seed fuer den Zufallsgenerator
SEED: .byte 1                       ; 1 Byte unter dem Namen 'SEED' reservieren
                                    ; Divisor fuer den Zufallsgenerator
DIVISOR: .byte 1                    ; 1 Byte unter dem Namen 'DIVISOR' reservieren
                                    ; Speicher fuer das Statusregister des Spiels
SREG_GAME: .byte 1                  ; 1 Byte unter dem Namen 'SREG_GAME' reservieren
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                    ; Konstantendefinition fuer die verschiedenen Symbole vom Raumschiff, die Explosion und dn Schuss
.equ	SYMBOL_SPACESHIP = 0        ; SPACESHIP ist Nummer 0
.equ	SYMBOL_SPACESHIP_FIRE = 1   ; SPACESHIP_FIRE ist Nummer 1
.equ	SYMBOL_EXPLOSION = 2        ; EXPLOSION ist Nummer 2
.equ	SYMBOL_FIRE = 3             ; FIRE ist Nummer 3

.equ    SYMBOL_ALIEN_SPEZIES_1 = 4  ; ALIEN_SPEZIES_1 ist Nummer 4
.equ    SYMBOL_ALIEN_SPEZIES_2 = 5  ; ALIEN_SPEZIES_2 ist Nummer 5
.equ    SYMBOL_ALIEN_SPEZIES_3 = 6  ; ALIEN_SPEZIES_3 ist Nummer 6

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                    ; Interrupt Vektor Tabelle
.cseg
.org $000                           ; Adresse der Interrupt-Vektor $000
	jmp		init
.org ADCCaddr
	jmp		ISR_ADC
                                    ; Timer/Counter Interrupt Mask Register
.org OC0addr                        ; hex 0x0026 / dez 38   
                                    ; Adresse der Interrupt-Vektor
                                    ; Timer/Counter0 Compare Match
	 jmp ISR_TIMER0					; springe nach erreichen des Vergleichswert an Timer/Counter0
                                    ; Timer/Counter Interrupt Mask Register
.org OC1Aaddr                       ; hex 0x000c / dez 12  
                                    ; Timer/Counter1 Compare Match A
	 jmp ISR_TIMER1					; springe nach erreichen des Vergleichswert an Timer/Counter1
                                    ; External Interrupt
.org INT2addr                       ; hex 0x0024 / dez 36 
                                    ; External Interrupt Request 2
	 rjmp ISR_INT2					; springe zu ISR_INT2

.org INT_VECTORS_SIZE
lcd_user_char:
	; Raumschiff		Raumschiff schiesst
	.db 0x00,			0x04
	.db 0x00,			0x04
	.db 0x00,			0x0A
	.db 0x04,			0x04
	.db 0x0A,			0x0A
	.db 0x0A,			0x0A
	.db 0x1B,			0x1B
	.db 0x15,			0x15
	; Explosion			Schuss
	.db 0x0A,			0x04
	.db 0x00,			0x00
	.db 0x11,			0x04
	.db 0x0A,			0x00
	.db 0x0A,			0x04
	.db 0x11,			0x00
	.db 0x00,			0x04
	.db 0x0A,			0x00
	; Alien Spezies 1	Alien Spezies 2
	.db 0x00,			0x00
	.db 0x00,			0x11
	.db 0x00,			0x1F
	.db 0x0E,			0x15
	.db 0x15,			0x1F
	.db 0x1B,			0x0A
	.db 0x0E,			0x0E
	.db 0x1B,			0x0A
	; Alien Spezies 3	Eigene Spezies
	.db 0x00,			0x00
	.db 0x00,			0x00
	.db 0x0E,			0x00
	.db 0x15,			0x04
	.db 0x0E,			0x0A
	.db 0x04,			0x0A
	.db 0x0A,			0x1B
	.db 0x11,			0x15
; End of Tab
	.db 0xFF, 0xFF

; Ansteuerung des LCDs
.include "lcd_port.asm"
; Zufallszahlgenerator
.include "random.asm"
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------
init:
	; Stackpointer
	ldi		R16,high(RAMEND)	                         ; Init
	out		SPH,R16				                         ; Stackptr 
	ldi		R16,low(RAMEND)		                         ; to end
	out		SPL,R16				                         ; of RAM

	; PortD
	ser		R16					                         ; R16 auf 11111111 (Ausgang)
	out		DDRD, R16			                         ; somit Port D auf Ausgabe gestellt

	clr		R16					                         ; R16 auf 00000000 (Eingang)
	out		DDRA, R16			                         ; Port A auf Eingabe
	out		DDRB, R16			                         ; Port B auf Eingabe

	call	lcd_init                                     ; Display initialisieren
	call	lcd_load_user_chars                          ; Symbole laden
    call	lcd_clear                                    ; Display lÃÂÃÂÃÂÃÂ¯ÃÂÃÂÃÂÃÂ¿ÃÂÃÂÃÂÃÂ½schen 

	                                                     ; Display
	call	lcd_init
	                                                     ; - Symbole laden
	call	lcd_load_user_chars
	                                                     ; - Display loeschen
	call	lcd_clear
	                                                     ; - Display neu zeichnen
	call	lcd_redraw
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	                                                     ; AD Wandler
	ldi		R16, (1 << ADLAR) |  (1<<REFS0)              ; ADLAR: ADC Left Adjust Result.
	                                                     ; Wenn das Bit gesetzt ist, wird das Ergebnis linksbÃÂÃÂ¼ndig abgelegt, andernfalls wird es rechtsbÃÂÃÂ¼ndig abgelegt.
														 ; (1<<REFS0) Das ist fÃÂÃÂ¼r die Spannung auswÃÂÃÂ¤hlen. AVCC mit externem Kondensator am AREF Pin.													 
    out		ADMUX, R16                                   ; ADMUX - ADC Multiplexer Selection Register
	ldi		R16, (1 << ADEN) | (1 << ADIE) | (1 << ADPS0); ADEN: ADC Enable
	                                                     ; Mit einer 1 in diesem Bit wird der ADC freigegeben
														 ; ADIE: ADC Interrupt Enable
														 ; Wenn dieses Bit gesetzt wird und auch das I-Bit im SREG die Interrupts global freigibt, dann ist der ADC Conversion Complete Interrupt freigegeben.
														 ; (1 << ADPS0) Das ist Teilungsfaktor des des Vorteilers
	out		ADCSRA, R16                                  ; ADCSRA ÃÂ¢ÃÂÃÂ ADC Control and Status Register A

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	                                                     ; Timer0
	ldi		R16, (1<<CS02)|(1<<CS00)|(1<<WGM01)          ; WGM01: CTC | CS02 und CS00 bedeutet processor clock/1024
	out		TCCR0, R16		                             ; Timer/Counter0 Control Register
	                                                     ; OCR0 -Output Compare 0
	ldi		R16, 100                                     ; Ersetzt OCR0 auf 100 (100ms)
	out		OCR0, R16                                    ; CTC: RÃÂÃÂ¼cksetzen nach Erreichen des Vergleichswerts
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	                                                     ; Timer1
	ldi		R16, (1<<CS12) | (1<<CS10) | (1<<WGM12)      ; WGM12:CTC | CS012 und CS10 bedeutet processor clock/1024
	out		TCCR1B, R16                                  ; TCCR1B -Timer/Counter1 Control RegisterB
	                                                     ; OCR1Ax -Output Compare 1A													 
	ldi		R16, high(1000)                              ; Da diese Register eine Breite von jeweils 16 Bit aufweisen, der ATmega16 jedoch lediglich ÃÂÃÂ¼ber einen
    out		OCR1AH, R16                                  ; 8 Bit breiten Datenbus verfÃÂÃÂ¼gt, mÃÂÃÂ¼ssen die Low- und High-Bytes der Register vom
	ldi		R16, low(1000)                               ; Assemblerprogramm aus einzeln angesprochen werden 
	out		OCR1AL, R16
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	                                                     ; Externer Interrupt
	ldi	    R16, (0<<ISC2)	                             ; fallende oder steigende flanke
	                                                     ; MCUCR -MCU Control Register
	out	    MCUCR, R16	                                 ; lade R16 auf MCUCR  
	                                                     ; GICR -The General Interrupt Control Register  
	ldi		R16, (1<<INT2)                               ; Aktivierung externer Interrupts
	out		GICR, R16                                    ; lade R16 auf GICR
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	                                                     ; Globale Aktivierung der Interrupts
	ldi		R16, (1<<OCIE1A)|(1<<OCIE0)                  ; Interrupt bei ÃÂÃÂberlauf . wenn I-flag gesetzt Adress des Interrupe-Vektors
	out		TIMSK, R16                                   ; Timer0 (1<<OCIE0) , Timer1(1<<OCIE1A)
	sei
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	; initiale Werte
	ldi     R16, 20                                      ; setzt R16 =20
	sts     AMMO, R16                                    ; lade AMMO auf 20
	clr     R16                                          ; setzt R16 =0
	sts     TIME, R16                                    ; lade TIME auf 0
	sts     POINTS, R16                                  ; lade POINTS auf 0
	sts     SPACESHIP, R16                               ; lade SPACESHIP auf 0
	ldi     R16, SYMBOL_ALIEN_SPEZIES_1                  ; setzt R16 =5
	sts     ALIEN_SPECIES, R16                           ; lade ALIEN_SPECIES 4(Alien_Spezies_1)
	clr     R16                                          ; setzt R16 =0

	; andere Initalisierungen
	ldi		R16, 14                                      ; setzt R16 =14
	sts		DIVISOR, R16                                 ; lade DIVISOR auf 14

	ldi		R16, 0x42                                    ; setzt R16 =Hex42
	sts		SEED, R16                                    ; lade SEED auf R16 

	jmp		main
;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
draw_spaceship:

	lds		R16, SPACESHIP_POSITION		                 ; Position des Raumschiffes in R16 laden
	ori		R16, 0b01000000					             ; Cursor-Position(Unterszeile ist SPACESHIP )
	                                                     ; ori ist logisches Oder with Immediate 
	call	lcd_setcursor					             ; Cursor wird an die Stelle gesetzt
      
	lds		R16, SYMBOL_SPACESHIP			             ; Lade Spaceship-Symbol in R16
	call	lcd_data						             ; Gib das Symbol aus
    			        											
Spaceship_Fire:								
									
	lds		R16, SREG_GAME					             ; Lade SREG_GAME in R16
	sbrs	R16, 0x04						             ; ÃÂÃÂ¯ÃÂÃÂ¿ÃÂÃÂ½berspringe, wenn Bit 4 gesetzt ist (skip if bit in register is set), 0x04 F-Flag
	rjmp	draw_finished					             ; andernfalls springe zu draw_finished
											             ; wenn F-Flag gesetzt, dann Fire ausgeben
	
	                                                     ; Cursor wird gesetzt
	lds		R16, SPACESHIP_POSITION			             ; Lade Pos des Schiffes in R16
	call	lcd_setcursor					             ; Aktualisiere Cursor

                                                         ; SYMBOL_FIRE wird ausgegeben
	ldi		R16, SYMBOL_FIRE                             ; Lade Fire in R16
	call	lcd_data                                     ; Gib das Schuss-Symbol aus 
											
	lds		R16, SREG_GAME
	andi	R16, 0b11101111				                 ; F-Flag wird zurÃÂÃÂ¯ÃÂÃÂ¿ÃÂÃÂ½ckgesetzt
	sts		SREG_GAME, R16

draw_finished:
	ret
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
draw_alien:
                                                         ; Cursor wird gesetzt
	lds		R16, ALIEN_POSITION                          ; Lade Pos des Alien in R16
	call	lcd_setcursor                                ; Aktualisiere Cursor

                                                         ; ALIEN_SPECIES wird ausgegeben
	lds		R16, ALIEN_SPECIES                           ; Lade Alien in R16
	call	lcd_data                                     ; Gib das Alien-Symbol aus
	ret

convert_value_to_pos:

	
	        cpi		R16, 20			
			brlo	pos_0			
			cpi		R16, 38			
			brlo	pos_1			
			cpi		R16, 56			
			brlo	pos_2			
			cpi		R16, 74			
			brlo	pos_3			
			cpi		R16, 92			
			brlo	pos_4			
			cpi		R16, 110		
			brlo	pos_5			
			cpi		R16, 128		
			brlo	pos_6			
			cpi		R16, 146		
			brlo	pos_7			
			cpi		R16, 164		
			brlo	pos_8			
			cpi		R16, 182		
			brlo	pos_9			
			cpi		R16, 200		
			brlo	pos_10			
			cpi		R16, 218		
			brlo	pos_11			
			cpi		R16, 236		
			brlo	pos_12			
			jmp		pos_13			
			clr R16
		pos_0:						
			ldi		R16, 0
			ret
		pos_1:						
			ldi		R16, 1
			ret
		pos_2:						
			ldi		R16, 2
			ret
		pos_3:						
			ldi		R16, 3
			ret
		pos_4:					
			ldi		R16, 4
			ret
		pos_5:						
			ldi		R16, 5
			ret
		pos_6:					
			ldi		R16, 6
			ret
		pos_7:					
			ldi		R16, 7
			ret
		pos_8:						
			ldi		R16, 8
			ret
		pos_9:						
			ldi		R16, 9
			ret
		pos_10:						
			ldi		R16, 10
			ret
		pos_11:				
			ldi		R16, 11
			ret
		pos_12:						
			ldi		R16, 12
			ret
		pos_13:						
			ldi		R16, 13
			ret
	ret
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ISR_TIMER1:

    push	R17
	push	R16
	in		R16, SREG 
	push	R16
	
	
	lds		R16, SREG_GAME             ; Ersetzt der Status des Spiel in R16
	sbrs	R16, 0                     ; keine Status ?
	jmp		end_isr_timer1             ; Wenn Ja ist, dann skip. Und es lÃÂÃÂ¤uft weiter.
                                       ; Wenn Nein ist, dann lauft end_isr_timer1 .
		
running_isr_timer1:
	lds		R16,  TIME                  ; Ersetzt time am Anfang 0
	inc		R16                         ; Time(R16)+1
	sts		TIME, R16                   ; Spreichen R16 auf TIME
	cpi		R16, 60                     ; Vergleichen Time und 60
	brne	spawn_alien                 ; Wenn Nein ist, bedeutet es noch Zeit gibt. 
                                        ; Wenn Ja ist, bedeutet es keine Zeit mehr hat
reset_isr_timer1:
	ldi		R16, 0b00000010             ; Dann ersetzt Status als Timer(Zeit ist abgelaufen)
	sts		SREG_GAME, R16              ; Dann speichen R16 in SREG_GAME
	jmp     end_isr_timer1                   

spawn_alien:
	call	rand			            ; In Random.asm
	sts		ALIEN_POSITION, R16         ; Bekommt den neue Position des Alien und spreicht in ALIEN_POSITION

	lds		R16, SREG_GAME              ; lade den Status auf R16
	sbrs	R16, 0b00000011             ; ob Status ist TundS(Spiel lÃÂÃÂ¤uft und Zeit ist abgelaufen)
	                                    ; das Bedeutet Zeit ist abgelaufen  
	jmp		end_isr_timer1

	call	new_alien_species           ; Sonst wird einen neue Alien darstellen
	lds		R16, SREG_GAME              ; lade den Status auf R16
	subi	R16, 0b00001000             ; ob Status ist Hit(der letzte Schuss war ein Treffer)
	sts		SREG_GAME, R16              ; dann darstellen eine neue Status und spreichen in SREG_GAME

		
end_isr_timer1:
	pop		R16
	out		SREG, R16                   ; SREG – Status Register
	                                    ; Das Status-Register wird beim Aufruf einer Interruptroutine nicht automatisch in den Stack gesichert 
										; oder nach dessen Beendigung aus dem Stack zurückgeholt. 
										; Beides muss durch die Interruptroutine sichergestellt werden.
	pop		R16
	pop		R17
	reti
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ISR_INT2:

	push	R17
	push	R16
	in		R16, SREG 
	push	R16
			 
	lds		R16, SREG_GAME              ; lade den Status auf R16
	sbrs	R16, 0					    ; Status ?
	jmp		set_isr_INT2		        ; Wenn ja ist, dann skip (laufen shoot_isr_INT2)
	jmp		shoot_isr_INT2		        ; Wenn Nein ist, laufen set_isr_INT2

                                        ; If game isnt running set flag and leave
set_isr_INT2:
	ldi		R16, 1                      ; ersetzt R16 auf 1 
	sts		SREG_GAME, R16              ; lade den Status auf R16
	jmp		end_isr_INT2             
		                                ; If game is runnnig check if hit
shoot_isr_INT2:                  
	lds		R16, SPACESHIP_POSITION     ; set cursor
	ori		R16, 0b01000000 
	call	lcd_setcursor
				
				                        ; Spaceship wird dargestellt
	ldi		R16, SYMBOL_SPACESHIP_FIRE  ; ersetzt SYMBOL_SPACESHIP_FIRE auf R16
    sts		SPACESHIP, R16              ; lade R16 auf SPACESHIP
	call	lcd_data                    ; Und ausgeben


	lds		R17, ALIEN_POSITION         ; ersetzt ALIEN_POSITION auf R17 
	lds		R16, SPACESHIP_POSITION     ; ersetzt SPACESHIP_POSITION auf R16 
	cp		R16, R17                    ; vergleichen R16 und R17(ob das treffen)
	brne	Miss			            ; Nicht getroffen
		
Hit:
			 
	lds		R16, SREG_GAME              ; ersetzt SREG_GAME auf R16
	ori		R16, 0b00001000             ; Im Status Start hat es getroffen (ori)
	sts		SREG_GAME, R16              ; lade R16 in Status SREG_GAME

Explosion:
	lds		R16, ALIEN_POSITION         ; set cursor
	call	lcd_setcursor               

	ldi		R16, SYMBOL_EXPLOSION       ; ersetzt SYMBOL_EXPLOSION auf R16
	sts		ALIEN_SPECIES, R16          ; lade R16 in ALIEN_SPECIES
	call	lcd_data                    ; ausgeben

	                                    ; Inc Points
	lds		R16, POINTS                 ; ersetzt POINTS auf R16
	inc		R16                         ; R16 +1
	sts		POINTS, R16                 ; lade R16 in POINTS
	jmp		end_isr_INT2
					                    ; Inc ammo
	lds		R16, AMMO                   ; ersetzt AMMO auf R16
	cpi	    R16, 20	                    ; wie viel Ammo es gibt(Maximal 20)
	breq	Explosion                   ; Wenn es getroffen
	inc		R16                         ; R16 +1
	sts		AMMO, R16                   ; lade R16 in AMMO

	
Miss:	         
	lds		R16, AMMO                   ; ersetzt AMMO auf R16
	dec		R16					        ; R16 -1
	cpi		R16, 0                      ; vergleichen R16 und 0 (ob das keine Ammo mehr ist)
	breq	No_Ammo				        ; Wenn Ja ist, bedeutet keine Ammo(laufen No_Ammo)
	sts		AMMO, R16                   ; Sonst lade R16 in AMMO
	lds		R16, SREG_GAME              ; ersetzt SREG_GAME auf R16
	ori		R16, 0b00010000		        ; Setzen des Fail Status( der letzte Schuss war kein Treffer)
	sts		SREG_GAME, R16              ; lade R16 in SREG_GAME
	jmp		end_isr_INT2
		
		
No_Ammo:
	ldi		R16, 0b00000100             ; ersetzt Ammo Status(Munition ist ler) auf R16
	sts		SREG_GAME, R16              ; lade R16 in SREG_GAME

		
end_isr_INT2:                           ; end
	pop		R16
	out		SREG, R16
	pop		R16
	pop		R17
	reti
;-------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                           ; A/D-Wandlung Rueckgabe der oberen acht Bit des A/D-Wertes
read_adc:
	ldi		R16, (1 << SM0) | (1 << SE)    ; Sleep Mode
	out		MCUCR, R16
	SLEEP
	sbi		ADCSRA, ADSC                   ; Problem with the Simulator: start A/D conversion manually
	in		R16, ADCH                      ; Wenn eine ADC-Wandlung abgeschlossen wurde, wird das Ergebnis in den beiden Registern ADCL und ADCH abgelegt. 
	                                       ; Wenn das ADCL-Register gelesen wurde,
										   ; werden beide Register so lange nicht mit Werten neuer Wandlungen aktualisiert, bis auch das ADCH gelesen wurde.
	ret

; ISR fuer die A/D-Wandlung
ISR_ADC:
	push	R16
	in		R16, SREG
	push	R16

	ldi		R16, (1 << SM0)                 ; Im Idle(Freizeit)
	out		MCUCR, R16                      ; MCU Control Register  

	pop		R16
	out		SREG, R16
	pop		R16
	reti
;-------------------------------------------------------------------------------------------------------------------------------------------------------------
; Anzeigen einer 2stelligen Zahl
draw_number:
	push	R16
	push	R17
	push	R18

	clr		R17                             ; Hexzahl - Dezimalzahl
loop:
	subi	R16, 0x0A                       ; Number muss ein Zahl sein, d.h wird es überprüfen, ob Number kleiner als 0x0A ist
	brmi	fin                             ; Wenn Ja ist, dann laufen fin
	inc		R17                             ; Wenn Nein ist, dann markiert R17 +1
	jmp		loop                            ; Weil R16 subtrahiert wird hat !!
fin:
	ldi		R18, 0x0A                       ; Ersetzt R18 auf 0x0A
	add		R16, R18                        ; R16 +0x0A (R16-0x0A+0x0A)

	ldi		R18, '0'                        ; Ersetzt R18 auf '0'
	add		R17, R18                        ; Jeder R17 bedeutet: Wie viel 0x0A es gibt (R17=Zehner)
	mov		R18, R16                        ; R18=Einer
	mov		R16, R17                  
	call	lcd_data                        ; Zehner ausgeben
	mov		R16, R18                     
	ldi		R18, '0'                        ; Ersetzt R18 auf '0'
	add		R16, R18                        ; Jeder R18 bedeutet: Wie viel 0x01 es gibt (R18=Einer)
	call	lcd_data                        ; Einer ausgeben

	pop		R18
	pop		R17
	pop		R16
	ret

ISR_TIMER0:
	push	R17
	push	R16
	in		R16, SREG
	push	R16

	call	lcd_clear

	lds		R16, SREG_GAME
	sbrc	R16, 0
	jmp		running_isr_timer0

	ldi		R16, 0x03
	call	lcd_setcursor
	ldi		R16, 'P'
	call	lcd_data
	ldi		R16, 'O'
	call	lcd_data
	ldi		R16, 'I'
	call	lcd_data
	ldi		R16, 'N'
	call	lcd_data
	ldi		R16, 'T'
	call	lcd_data
	ldi		R16, 'S'
	call	lcd_data
	ldi		R16, ':'
	call	lcd_data
	ldi		R16, ' '
	call	lcd_data
	lds		R16, POINTS
	call	draw_number

	lds		R16, SREG_GAME
	sbrs	R16, 1                        ; ob das Stoppen wegens N0_Zeit
	jmp		test_no_ammo_isr_timer0       ; Wenn Ja ist, dann skip
	                                      ; Wenn Nein ist, das beduetet: die Grund des Stoppen ist No_Ammo

	ldi		R16, 0x43                     ; Ja-Ausgeben
	call	lcd_setcursor
	ldi		R16, 'T'
	call	lcd_data
	ldi		R16, 'I'
	call	lcd_data
	ldi		R16, 'M'
	call	lcd_data
	ldi		R16, 'E'
	call	lcd_data
	ldi		R16, ' '
	call	lcd_data
	ldi		R16, 'O'
	call	lcd_data
	ldi		R16, 'V'
	call	lcd_data
	ldi		R16, 'E'
	call	lcd_data
	ldi		R16, 'R'
	call	lcd_data
	ldi		R16, '!'
	call	lcd_data

	jmp		end_isr_timer0

test_no_ammo_isr_timer0:            
	lds		R16, SREG_GAME                  ; Nein-Ausgeben
	sbrs	R16, 2
	jmp		end_isr_timer0

	ldi		R16, 0x44
	call	lcd_setcursor
	ldi		R16, 'N'
	call	lcd_data
	ldi		R16, 'O'
	call	lcd_data
	ldi		R16, ' '
	call	lcd_data
	ldi		R16, 'A'
	call	lcd_data
	ldi		R16, 'M'
	call	lcd_data
	ldi		R16, 'M'
	call	lcd_data
	ldi		R16, 'O'
	call	lcd_data
	ldi		R16, '!'
	call	lcd_data

	jmp		end_isr_timer0

running_isr_timer0:                         ; Im Laufen
	call	draw_spaceship                  ; Unterprogramm draw_spaceship aufrufen
	call	draw_alien                      ; Unterprogramm draw_alien aufrufen
	                                        ; Position der Zeit auf dem Display
	ldi		R16, 0x0E                       ; Am Position 0x0E
	call	lcd_setcursor
	lds		R16, TIME
	call	draw_number
	                                        ; Position der Munition auf dem Display
	ldi		R16, 0x0E
	ori     R16, 0b01000000                 ; Am Position 0x4E
	call	lcd_setcursor
	lds		R16, AMMO
	call	draw_number

end_isr_timer0:                         
	call	lcd_redraw                    
	pop		R16
	out		SREG, R16
	pop		R16
	pop		R17
	reti

new_alien_species:
	push	R16
	ldi		R16, 4
	sts		DIVISOR, R16
	call	rand
	subi	R16, -4
	sts		ALIEN_SPECIES, R16
	ldi		R16, 14
	sts		DIVISOR, R16
	pop		R16
	ret
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
main:
loop_start:
	; Warten auf Start
	lds		R16, SREG_GAME
	sbrs	R16, 0                  ; Ob das jetzt gespielt wird
	jmp		loop_start              ; Wenn Ja ist, dann Skip
	                                ; Wenn Nein ist, dann noch mal prüfen.
	; seed setzen
	in		R16, TCNT1L   
	cpi		R16, 0
	breq	loop_game
	sts		SEED, R16

loop_game:                           ; Im Spiel
	call	read_adc                 ; die A/D Wandelung ablesen
	call	convert_value_to_pos     ; die Position ablesen
	sts		SPACESHIP_POSITION, R16  ; die Position des Spaceship speichen
	lds		R16, SREG_GAME           ; Status des Spiel
	; Spiel zu Ende? 
	sbrc	R16, 0                   ; Ob das Spiel noch laufen
	jmp		loop_game                ; Wenn Ja ist, laufen weiter loop_game
                                     ; Wenn Nein ist, bedeutet: Das Spiel ist Stoppen
loop_end:
	; In dieser Loop bleiben um Punkte korrekt anzuzeigen
	lds		R16, SREG_GAME
	andi	R16, 0x06

	brne	loop_end

	; Reset
	clr		R16
	sts		TIME, R16
	sts		POINTS, R16
	sts		SPACESHIP, R16

	ldi		R16, 5
	sts		ALIEN_SPECIES, R16

	ldi		R16, 0x42
	sts		SEED, R16

	ldi		R16, 20
	sts		AMMO, R16

	jmp		main
