#include <xc.inc>
    ;psect code

    movlw   0x0a
    movwf   0x20, f, a
    
    movlw   0x07
    movwf   0x21, f, a
    
    addwf   0x20, w, a
    
    sum	equ 0x32
    movwf   sum, f, a
    

    
end