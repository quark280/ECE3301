#include <xc.inc>
    goto start	
    
    ;Lab3_FinalCode
    psect code
   N   equ	0x00	; Number of X's
   Z   equ 0x60	; Final answer is stored here
   X   equ 0x50	; Starting point of Xi array

start:	; load location 0x50 to 0x57 with arbitrary numbers for testing
	; you should also use "Memory Fill" to test it with zeros, ones, or even random numbers
	lfsr	0, X
	movlw	1
	movwf	POSTINC0, a
	movlw	2
	movwf	POSTINC0, a
	movlw	3
	movwf	POSTINC0, a
	movlw	4
	movwf	POSTINC0, a
	movlw	5
	movwf	POSTINC0, a
	movlw	6
	movwf	POSTINC0, a
	movlw	7
	movwf	POSTINC0, a
	movlw	8
	movwf	POSTINC0, a
	
	movlw	8
	movwf	N, a 
	lfsr    1, X 

loop:
	call	sum8, 1 ;summon the subroutine
	decfsz	N, f, a 
	bra	loop	
	
	movlw	3
	movwf	N, a 

loop2:	call	divide, 1 
	decfsz	N, f, a 
	bra	loop2 
	bra	stop 
    	
sum8:	
    movf    POSTINC1, w, a
    addwf   Z, f, a 
    return  1 

divide:
    rrcf    Z, f, a 
    bcf	    STATUS, 0, a 
    return  1 

stop:	bra	stop
	
end
