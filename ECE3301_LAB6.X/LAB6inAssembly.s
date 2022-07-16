config OSC = INTIO2
config BOR = OFF        ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
config STVREN = OFF     ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will not cause Reset)
config WDT = OFF        ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
config MCLRE = ON       ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#include <xc.inc>    
    goto start    
    
   
    psect data  
lookup:    DB  0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90, 0x88, 0x83, 0xC6, 0xA1, 0x86, 0x8E    
    
    psect code
    SSEG    EQU 0x41    ; 7 segment pattern table starting address in data memory
    I    EQU 0x70	; used as a counter index
    val1    EQU 0x30    ;first value
    val2    EQU 0x31   ; second value
start:    

    movlw    low lookup
    movwf    TBLPTRL, f, a
    movlw    high lookup
    movwf    TBLPTRH, f, a
    movlw    low highword lookup
    movwf    TBLPTRU, f, a
    
    lfsr    0, SSEG 
    movlw    16
    movwf    I, f, a 
 loop:    TBLRD*+	  ;read 1B from program memory and advance TBLPTR by 1
    movff    TABLAT, POSTINC0 
    decf    I, f, a;
    bnz    loop
    
    ; set the I/O port directions
    setf    ADCON1, a   
    clrf    TRISA, a	;output connected to 7seg  
    setf    TRISD, a    ;input  connected to 6 switches
    
    ; start the read/display
infiniteloop:
    movf    PORTD, w, a 
    andlw    0x07        
    movwf    val1, a       
    movf    PORTD, w, a
    movwf   val2,a
    rrncf    val2, f, a  ;rotate
    rrncf    val2, f, a  ;rotate
    rrncf    val2, f, a  ;rotate
    addwf    val1, a        
    call    bcd2sseg, 0 
    movwf    PORTA, a    
    bra    infiniteloop    
    
   
bcd2sseg: 
    lfsr    0, SSEG; move fsr0 pointer back to start of table
    movf    PLUSW0, w, a
    return 0; WREG will have the sseg pattern upon return
    
end 
