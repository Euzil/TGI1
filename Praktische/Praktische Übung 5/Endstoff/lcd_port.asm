;
; lcd_port.asm
;
;  Created: 24.06.2020 15:50:23
;   Author: Waiel Aljnabi
;
; Sammlug an Unterprogrammen, um mit dem LCD des Simulators zu kommunizieren
;

.cseg

.equ LCD_PORT = PORTD
.equ LCD_DDR  = DDRD



.def lcd_tmp1 = r23
.def lcd_tmp2 = r24
.def lcd_tmp3 = r25


; Initialisierung: muss ganz am Anfang des Programms aufgerufen werden
lcd_init:
	; Set baud rate (high and low byte)
	ser		lcd_tmp1
	out		LCD_DDR, lcd_tmp1
	ret


;sendet ein Datenbyte an das LCD
lcd_data:
	ldi		lcd_tmp1, 'D'
	out		LCD_PORT, lcd_tmp1
	mov		lcd_tmp1, R16
	out		LCD_PORT, lcd_tmp1
	ret

; Sendet den Befehl zur Loeschung des Displays
lcd_clear:
	ldi		lcd_tmp1, 'C'
	out		LCD_PORT, lcd_tmp1
	ret

; Sendet den Befehl zur Aktualisierung des Displays
lcd_redraw:
	ldi		lcd_tmp1, 'R'
	out		LCD_PORT, lcd_tmp1
	ret

; Cursor Home
lcd_home:
	ldi		lcd_tmp1, 'H'
	out		LCD_PORT, lcd_tmp1
	ret

;**********************************************************************
;
; Laedt User Zeichen in den GC-Ram des LCD bis Tabellenende (0xFF)
; gelesen wird. (max. 8 Zeichen koennen geladen werden)
;
; Uebergabe:            -
; veraenderte Register: lcd_tmp1, lcd_tmp2, lcd_tmp3, zh, zl
; Bemerkung:            ist einmalig nach lcd_init aufzurufen
;
lcd_load_user_chars:
	ldi		ZL, LOW (lcd_user_char << 1)	; Adresse der Zeichentabelle
	ldi		ZH, HIGH(lcd_user_char << 1)	; in den Z-Pointer laden

	clr		lcd_tmp3						; aktuelles Zeichen = 0

lcd_load_user_chars_2:
	clr		lcd_tmp2						; LinienzÃÂ¤hler = 0

lcd_load_user_chars_1:
	ldi		lcd_tmp1, 'S'
	out		LCD_PORT, lcd_tmp1
	mov		lcd_tmp1, lcd_tmp3
	add		lcd_tmp1, lcd_tmp2
	out		LCD_PORT, lcd_tmp1

	ldi		lcd_tmp1, 'L'
	out		LCD_PORT, lcd_tmp1
	lpm		lcd_tmp1, Z+
	out		LCD_PORT, lcd_tmp1

	ldi		lcd_tmp1, 'S'
	out		LCD_PORT, lcd_tmp1
	mov		lcd_tmp1, lcd_tmp3
	add		lcd_tmp1, lcd_tmp2
	subi	lcd_tmp1, -8
	out		LCD_PORT, lcd_tmp1

	ldi		lcd_tmp1, 'L'
	out		LCD_PORT, lcd_tmp1
	lpm		lcd_tmp1, Z+
	out		LCD_PORT, lcd_tmp1

	inc		lcd_tmp2					; LinienzÃÂ¤hler + 1
	cpi		lcd_tmp2, 8					; 8 Linien fertig?
	brne	lcd_load_user_chars_1		; nein, dann nÃÂ¤chste Linie

	subi	lcd_tmp3, -0x10				; zwei Zeichen weiter (addi 0x10)
	lpm		lcd_tmp1, Z					; nÃÂ¤chste Linie laden
	cpi		lcd_tmp1, 0xFF				; Tabellenende erreicht?
	brne	lcd_load_user_chars_2		; nein, dann die nÃÂ¤chsten
										; zwei Zeichen
	ret

; Setz die position des Cursors
lcd_setcursor:
	ldi		lcd_tmp1, 'M'
	out		LCD_PORT, lcd_tmp1
	mov		lcd_tmp1, R16
	out		LCD_PORT, lcd_tmp1
	ret
