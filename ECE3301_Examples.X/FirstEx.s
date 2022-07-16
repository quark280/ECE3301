
	
	
	
	
#include <xc.inc>
	goto start	
	
	; 7 Segment translator
	
	psect data  
lookup:	DB  0xF9, 0xF3, 0xE7, 0xCF, 0xDE, 0xFC	
	
	psect code
SSEG	EQU 0x41    ; 7segment pattern table starting address in data memory
I	EQU 0x70    ; used as a counter index
start:	; load TBLPTR with the address of lookup
	movlw	low lookup
	movwf	TBLPTRL, f, a
	movlw	high lookup
	movwf	TBLPTRH, f, a
	movlw	low highword lookup
	movwf	TBLPTRU, f, a
	
	; move table from program to data memory
	lfsr	0, SSEG ; starting address in data memory
	movlw	10
	movwf	I, f, a ; initialize counter with 10
	
loop:	TBLRD*+    ; read 1B from program memory and advance TBLPTR by 1
	movff	TABLAT, POSTINC0 ;copy TABLAT into INDF0 them move FSR0 pointer forward
	decf	I, f, a;
	bnz	loop
	
	
	movlw	4
	lfsr 0, SSEG
	movf PLUSW0, w, a
	
stop:	bra	stop


