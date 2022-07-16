#include <stdio.h>
#include <stdlib.h>
#include "config.h"

int main() 
{
char sevenseg[16] = {0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90, 0x88, 0x83, 0xC6, 0xA1, 0x86, 0x8E};
    
    // Turn off ADC
    ADCON1 = 0xff; 
    
    // PORTA is output (connected to 7segment display)
    TRISA = 0x00; 
    
    // PORTD is input (conntected to switches)
    TRISD = 0xff; 
    
    int firstum = 0;
    int secondnum = 0;

    
    while(1)
    {
       firstnum = (PORTD & 0x07);   //getting the first 3 bits
       secondnum = (PORTD >> 3);    //getting the next 3 bits by shifting
       PORTA = sevenseg[(firstnum + secondnum)];
        //PORTD = sevenseg[PORTB & 0x0F];
        
    }
    return (EXIT_SUCCESS);
}
