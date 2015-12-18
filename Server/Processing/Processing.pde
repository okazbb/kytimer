/**
 * Library
 */
import processing.serial.*;
Serial myPort;

import java.util.Queue;
import java.util.ArrayDeque;
Queue<Integer> queue;

/**
 * Settings
 */
String FONT_NAME = "Osaka";
int FONT_COLOR = #FFFFFF;
int BG_COLOR = #000000;
boolean DEBUG = true;
boolean USE_WATCH = true;
boolean USE_MOUSE = true;
int DISPLAY_DELAY_TIME = 180;
int START_DELAY_TIME = 3000;
int GOAL_DELAY_TIME = 3000;

/**
 *
 */
int time_m = 0;
int time_s = 0;
int time_ms = 0;

int start;
int goal;
int millisecond;
int second;
int before_ms;
int w_ms = 0;

int draw_ms = millis();
int start_ms = 0;
int goal_ms = 0;

void setup(){
  if(DEBUG) println(Serial.list());
  
  //myPort = new Serial(this, "/dev/tty.usbmodem411", 9600);
  queue = new ArrayDeque<Integer>();
  
  background(BG_COLOR);
  size(1366, 768);
  //size(1280, 800);
  //size(1440, 900);
  //size(640, 480);
  //size(displayWidth, displayHeight);
  drawTime(0, 0, 0, 0);
  
}

void draw(){

  int ms = millis();
  if(draw_ms + DISPLAY_DELAY_TIME > ms) return;
  draw_ms = ms;

  if(before_ms + DISPLAY_DELAY_TIME < ms){  
      w_ms = ms;
  }
    
  drawTime(time_m, time_s, time_ms, queue.size());
  drawWatch();

}

void start_sw(String ms_string){
  
  int ms = millis();
  if(start_ms + START_DELAY_TIME > ms) return;
  start_ms = ms;
  
  if(ms_string == ""){
    queue.add(millis());
    
  } else {
    int start_ms = int(ms_string);
    queue.add(start_ms);
    if(DEBUG) println("START" + ms_string);
  }
  
}

void goal_sw(String ms_string){

  int ms = millis();
  if(goal_ms + GOAL_DELAY_TIME > ms) return;
  goal_ms = ms;

  if(ms_string == ""){
    goal = millis();
  } else {
    int goal_ms = int(ms_string);
    goal = int(goal_ms);
    if(DEBUG) println("GOAL" + goal_ms);
  }
  
  try{
    start = queue.remove();
    millisecond = goal - start;
    second = millisecond / 1000;
    
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
  
}

void serialEvent(Serial p) {
  
  String s = p.readStringUntil(10);  
  if (s != null) {
    String data = trim(s);
    String command = data.substring(0, 1);
    String time_val = data.substring(1);
    
    if(DEBUG) println(command);
    
    if(command.equals("S")){
      start_sw(time_val);
      if(DEBUG) println("start" + time_val);
      
    } else if(command.equals("G")){
      goal_sw(time_val);
      if(DEBUG) println("goal" + time_val);
      
    } else if(command.equals("T")){
      w_ms = int(time_val);
    }
  }
}

void mousePressed(){
  
  if(!USE_MOUSE) return;
  
  switch(mouseButton){
    case LEFT: //START
      start_sw("");
      break;
    
    case RIGHT: //GOAL 
      goal_sw("");
      break;
  }
}

void drawWatch(){

  if(!USE_WATCH) return;
  
  int l_ms;
  if(queue.size() > 0){
    l_ms = w_ms - queue.element(); 
  } else {
    l_ms = millisecond;
  }
   
  int ls = l_ms / 1000;
  int w_time_m = ls / 60;
  int w_time_s = ls % 60;
  int w_time_ms = l_ms % 1000;
    
   fill(0,0,0);
   rect(
     20,
     height / 1.4,
     250,
     250
   );
   
   fill(255,255,255);
   textAlign(LEFT);
   int fontSize = height / 18;
   PFont fn2 = createFont(FONT_NAME, fontSize);
   textFont(fn2);
   text(
      nf(w_time_m, 2) + ":" + nf(w_time_s, 2) + "." + nf(w_time_ms, 3),
      20,
      height / 1.2
    );
 
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
  
  //running
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