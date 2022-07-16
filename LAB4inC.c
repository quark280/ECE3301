#include <stdio.h>
#include <stdlib.h>
#include "config.h"

#define LED1 PORTCbits.RC0
#define LED2 PORTDbits.RD0
#define SWITCH1 PORTCbits.RC1
#define SWITCH2 PORTDbits.RD1

    
int main() 
{
    ADCON1 = 0xff;
    TRISC = 0x02;
    TRISD = 0x02;
    
    while(1)
    {    
        if(SWITCH1 == 1)
            LED1 = 0;
        else
            LED1 = 1; 

        if(SWITCH2 == 1) 
            LED2 = 0;
        else
            LED2 = 1;
    }
    
    return (EXIT_SUCCESS);
}
