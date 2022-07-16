config OSC = INTIO2
config BOR = OFF        ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
config STVREN = OFF     ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will not cause Reset)
config WDT = OFF        ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
config MCLRE = ON       ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#include <xc.inc>	
	goto start	
	

	
	psect data  
lookup:	DB  0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90, 0x88, 0x83, 0xC6, 0xA1, 0x86, 0x8E
	
	psect code
SSEG	EQU 0x41    ; 7seg pattern table 
I	EQU 0x70    ; counter
start:	
	
	movlw	low lookup
	movwf	TBLPTRL, f, a
	movlw	high lookup
	movwf	TBLPTRH, f, a
	movlw	low highword lookup
	movwf	TBLPTRU, f, a
	
	lfsr	0, SSEG 
	movlw	16	; set asside 16 bits 
	movwf	I, f, a ; initialize counter with 16
loop:	TBLRD*+    
	movff	TABLAT, POSTINC0 ;copy TABLAT into INDF0 them move FSR0 pointer forward
	decf	I, f, a;
	bnz	loop
	
	; set the I/O port directions
	setf	ADCON1, a   ; turn off the ADC
	clrf	TRISA, a    ; output connected to 7seg
	setf	TRISB, a    ; input  connected to 4 switches
	
	
infiniteloop:
	movf	PORTB, w, a 
	andlw	0x0f	    
	call	bcd2sseg, 0
	movwf	PORTA, a
	bra	infiniteloop
    
	
bcd2sseg: 
	lfsr	0, SSEG; 
	movf	PLUSW0, w, a
	return 0; 
	
end


