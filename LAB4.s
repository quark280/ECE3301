config OSC = INTIO2
config BOR = OFF        ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
config STVREN = OFF     ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will not cause Reset)
config WDT = OFF        ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
config MCLRE = ON       ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#include <xc.inc>
	goto start	
	
	
	psect code

start:	
	setf	ADCON1, a   ; Turn off ADC inputs
	clrf	TRISC, a    ; PORTC is output
	setf	TRISD, a    ; PORTD is input
	
infloop1:
	movf	PORTD, w, a
	andlw	0x02 ; keep the values of bits 6 and 7
	bz	ledon	    ; if bits 6 and 7 are both low, turn led on
	sublw	0x02
	bz	ledon	    ; if bits 6 and 7 are both high, turn led on
	bsf	PORTC, 7, a ; turn off led (cathode connected to port)
	bra	ledon_D

infloop2:
	movf	PORTC, w, a
	andlw	0x02 ; keep the values of bits 6 and 7
	bz	ledoff	    ; if bits 6 and 7 are both low, turn led on
	sublw	0x02
	bz	ledoff	    ; if bits 6 and 7 are both high, turn led on
	bsf	PORTC, ; turn off led (cathode connected to port)
	bra	ledon_C
	
ledon_C:	bcf	PORTC, 7, a ; turn on led (cathode connected to port)
	bra	infloop1
	
ledoff_D:	bsf	PORTD, 7, a ; turn off led (cathode connected to port)
	bra	infloop2
	
ledon_D:	bcf	PORTD, 7, a ; turn on led (cathode connected to port)
	bra	infloop2
	
ledoff_C:	bsf	PORTC, 7, a ; turn off led (cathode connected to port)
	bra	infloop1
		
	
end