#include "mbed.h"
 
DigitalIn start_switch(PB_8);
DigitalOut watch_switch(PA_7);
DigitalOut led(LED1);
 
int main() {
    
    while(1) {
        if(start_switch == 1){
            watch_switch = 1;
            wait(2.0);
            watch_switch = 0;
        }
        wait(0.001);
    }
}
