
#include <stdio.h>
#include <stdlib.h>
#include "config.h"

# define SWITCH1 PORTDbits.RD0
# define SWITCH2 PORTDbits.RD1


// Specify the "crystal frequency" in Hz. This is necessary for __delay_ms(n) or __delay_us(n)
# define _XTAL_FREQ 1000000 


int main() 
{
    char sseg[6] = {0xF9, 0xF3, 0xE7, 0xCF, 0xDE, 0xFC}; 
    //0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90, 0x88, 0x83, 0xC6, 0xA1, 0x86, 0x8E
    
    // Turn off ADC
    ADCON1 = 0xff;
    
    // PORTA is output (connected to 7segment display)
    TRISA = 0x00;
    
    int counter1 = 0;   //counter for the clockwise direction 
    int counter2 = 5;   //counter for the counterclockwise direction 
    while (1)
    {

        if ((SWITCH1 == 0) && (SWITCH2 == 1)) //In truth table: 01 which toggles G
        {
             
            
           PORTA = 0xBF;
           __delay_ms(500); // request a delay in milliseconds 
           
           PORTA = 0xFF;
           __delay_ms(500); // request a delay in milliseconds 
        }
        
        if ((SWITCH1 == 1) && (SWITCH2 == 0)) //In truth table: 10 which rotates clockwise
        {
        PORTA = sseg[counter1 & 0x0F];
        __delay_ms(500); // request a delay in milliseconds 
        //__delay_us(1000000); // request a delay in microseconds 
        counter1 = (counter1 + 1) % 6;
      
        }
        
        if ((SWITCH1 && SWITCH2) == 1) //In truth table: 10 which rotates counter-clockwise
        {
           
        PORTA = sseg[counter2 & 0x0F];
        __delay_ms(500); // request a delay in milliseconds 
        //__delay_us(1000000); // request a delay in microseconds 
        counter2 = (counter2 - 1) % 6;
        
        if (counter2 < 0)
        {
            counter2 = 5;
        }
        }
        
        
      PORTA = 0xFF; //default is seven segment display off
    
    }
    return (EXIT_SUCCESS);
}