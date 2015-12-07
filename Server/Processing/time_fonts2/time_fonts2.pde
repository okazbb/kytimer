//show time sample
import processing.serial.*;
Serial sp;

import java.util.Queue;
import java.util.ArrayDeque;
Queue<Integer> queue;

String FONT_NAME = "Osaka";
int FONT_COLOR = #FFFFFF;
int BG_COLOR = #000000;
boolean DEBUG = true;

int time_m = 0;
int time_s = 0;
int time_ms = 0;
    
void setup(){
  background(BG_COLOR);
  size(1366, 768);
  //size(1280, 800);
  //size(1440, 900);
  //size(640, 480);
  //size(displayWidth, displayHeight);
  drawTime(0, 0, 0, 0);
  queue = new ArrayDeque<Integer>();
  //myPort = new Serial(this, "/dev/tty.usbmodem1411", 9600);
}

void draw(){
  if(keyPressed){    
    //START
    if(key == 'i'){
      queue.add(millis());
      delay(100);
    }
    
    //GOAL
    if(key == 'o'){ 
      int goal = millis();
      try{
        int start = queue.remove();
        int millisecond = goal - start;
        int second = millisecond / 1000;
        
        if(DEBUG){
          println("start:" + str(start));
          println("goal:" + str(goal));
          println("realtime:" + str(millisecond));
        }
        
        time_m = second / 60;
        time_s = second % 60;
        time_ms = millisecond % 1000;
      
      } catch(Exception e){
        time_m = time_s = time_ms = 0;
      }
      delay(100);
    }
    drawTime(time_m, time_s, time_ms, queue.size());
  }
}

void drawTime(int time_m, int time_s, int time_ms, int running){
  background(#000000);
  
  
  float fontSize = height / 2.2;
  PFont fn = createFont(FONT_NAME, fontSize);
  fill(#FFFFFF);
  textFont(fn);
  textAlign(CENTER);
  
  //99:99
  text(
    nf(time_m, 2) + ":" + nf(time_s, 2),
    width / 2,
    height / 2.2
  );
  
  //.999
  text(
    "." + nf(time_ms, 3),
    width / 1.6,
    height / 1.1 
  );
  
  textAlign(LEFT);
  fontSize = height / 18;
  PFont fn2 = createFont(FONT_NAME, fontSize);
  textFont(fn2);
  text(
     "RUNNING: " + str(running),
    20,
    height / 1.7
  );
}