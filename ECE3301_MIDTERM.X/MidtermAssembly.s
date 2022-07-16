config OSC = INTIO2
config BOR = OFF        ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
config STVREN = OFF     ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will not cause Reset)
config WDT = OFF        ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
config MCLRE = ON       ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#include <xc.inc>	
	goto start	
	
	;Midterm double switches with 4 patterns
	
	psect data  
lookup:	DB  0xF9, 0xF3, 0xE7, 0xCF, 0xDE, 0xFC
	    ;0xF9, 0xF3, 0xE7, 0xCF, 0xDE, 0xFC Midterm Pattern
	    ;0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90, 0x88, 0x83, 0xC6, 0xA1, 0x86, 0x8E	1,2,3,4... Patter
	psect code
SSEG	EQU 0x40    ; 7segment pattern table starting address in data memory
I	EQU 0x70    ; used as a counter index
temp1	EQU 0x10
temp2	EQU 0x90

start:	
	; Move the 7seg pattern from program memory into data memory
	movlw	low lookup
	movwf	TBLPTRL, f, a
	movlw	high lookup
	movwf	TBLPTRH, f, a
	movlw	low highword lookup
	movwf	TBLPTRU, f, a
	
	lfsr	0, SSEG ; starting address in data memory
	movlw	6
	movwf	I, f, a ; initialize counter with 6
	
	
loop:	TBLRD*+    ; read 1B from program memory and advance TBLPTR by 1
	movff	TABLAT, POSTINC0 ;copy TABLAT into INDF0 them move FSR0 pointer forward
	decf	I, f, a;
	
	bnz	loop
	
	; set the I/O port directions
	setf	ADCON1, a   ; turn off the ADC
	clrf	TRISA, a    ; output connected to 7seg
	setf	TRISD, a    ; input  connected to 2 switches
	
; start the read/display
infiniteloop:
	
	movlw	0xff
	movwf	PORTA, a
	movf	PORTD, w, a
	andlw	00000011B   ;lowest 2 bits
	bz	blank
	
	btfss	PORTD, 1, a
	bra	negativeToggle ;branch to toggle
	
	btfsc	PORTD, 0, a	;checking either branch 
	;branch to either one depending on the switch
	bra	counterclockwiseSet
	bra	clockwiseSet

;should display blank 
blank:
	movlw	0xff
	movwf	PORTA, a
	bra	infiniteloop
	
;displays only the center of the SSEG
negativeToggle:
	movlw	0xBF	;Hex code for lighting up G only on SSEG
	
	movwf	PORTA, a
	call	delay500ms
	movlw	0xFF
	movwf	PORTA, a
	call	delay500ms
	bra	infiniteloop
	
;set up the counter clockwise	
counterclockwiseSet:
	movlw	6
	movwf	temp1, a
	movlw	0xF9	;set one side of pattern
	movwf	PORTA,a
	call	delay500ms,0
	movf	temp1,w,a
    
;loop through counter clockwise
counterclockwiseLoop:
	call	bcd2sseg, 0
	movwf	PORTA,a
	call	delay500ms
	movlw	00000011B
	CPFSEQ	PORTD, 0
	bra	infiniteloop
	movlw	1
	subwf	temp1, f, a
	bz	counterclockwiseSet
	bra	counterclockwiseLoop
	
;set up the clockwise
clockwiseSet:
	movlw	6
	movwf	temp2,a
	movlw	1
	movwf	temp1,a
	movlw	0xF9 ;set one side of pattern
	movwf	PORTA, a
	clrf	temp1	;clear temp
	call	delay500ms, 0
	movf	temp1, w, a
	
;loop through clockwise 
clockwiseLoop:
	call	bcd2sseg, 0
	movwf	PORTA, a
	call	delay500ms
	movlw	00000010B
	CPFSEQ	PORTD, 0
	bra	infiniteloop
	;add to temps to loop through 
	movlw	1
	addwf	temp1, f, a
	movwf	temp1, w, a
	CPFSEQ	temp2, 0
	bra	clockwiseLoop
	
; convert a BCD pattern stored in 4 lsb of WREG into 7Seg
bcd2sseg: 
	lfsr	0, SSEG	; move fsr0 pointer back to start of table
	movf	PLUSW0, w, a
	return 0	; WREG will have the sseg pattern upon return

delay2550us:			   
	movlw	255
l1:	decf	WREG, w, a
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bnz	l1
	return 1

delay500ms:			    
	movlw	100		    
	movwf	0x10, a
l2:	call	delay2550us
	decf	0x10, f, a
	bnz	l2
	return 1
		
end

