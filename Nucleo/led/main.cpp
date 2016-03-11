#include "mbed.h"
#include <string>
 
//board
Serial timerLed(PB_6, PA_10);
DigitalOut led(LED1); //onboard led
DigitalIn startSW(PB_8);
DigitalIn goalSW(PB_9);
 
//setting
const int DRAW_DELAY    = 235;
const int SWITCH_DELAY  = 2000;
const int LED_DELAY     = 1500;
 
//local
int system_time = 0;
int draw_time   = 0;
int start_time  = 0;
int goal_time   = 0;
int led_time    = 0;
bool running    = false;
Timer system_timer;
Timer timer; //https://developer.mbed.org/users/okini3939/notebook/timer_jp/
//time https://developer.mbed.org/users/okini3939/notebook/time_jp/
 
/*
 * LED表示
 */
void drawLED(int ms){
    int sec = ms / 1000;
    int time_min = sec / 60;
    int time_sec = sec % 60;
    int time_ms  = ms % 1000;
    
    
    //TODO 0.004秒遅延する
 
    char s[9];
    sprintf(s, "%01d.%02d.%03d-%1d", time_min, time_sec, time_ms, running);
    string str(s);
    for(int i = 0; i < (int)str.size(); ++i){
        char ch = str[i];
        timerLed.putc(str[i]);
        wait(0.01);
    }
    if(running){
        timerLed.putc('1');
    } else {
        timerLed.putc('0');
    }
    wait(0.01);
    timerLed.printf("\r");
}
 
/*
 * start
 */
void start(){
    timer.start();
    running = true;
}
 
/*
 * goal
 */
void goal(){
    timer.stop();
    running = false;
    
    drawLED(timer.read_ms());
    timer.reset();
}
 
/*
 * Main
 */    
int main() {
 
  int i = 0;
  system_timer.start();
  
  wait(1);
    timerLed.format(8, Serial::None, 1);
    drawLED(0);      
    
  while(1) {       
    system_time = system_timer.read_ms();
    
    //start or goal
    if(goalSW == 1){
        if(start_time + SWITCH_DELAY <= system_time){
            start_time = system_time;
            if(running){
                goal();
            } else {
                start();
            }
            
        }
    }
    
    //draw led
    if(running && draw_time + DRAW_DELAY <= system_time){
        draw_time = system_time;
        drawLED(timer.read_ms());
    }
  
    //led signal
    if(led_time + LED_DELAY <= system_time){
        led_time = system_time;
        led = !led;
        i++;
        if(i > 9) i = 0;
    }
    
 
}
}
