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
boolean DEBUG = false;
boolean USE_WATCH = false;
boolean USE_MOUSE = true;
int DISPLAY_DELAY_TIME = 150;
int START_DELAY_TIME = 2000;
int GOAL_DELAY_TIME = 2000;

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

int draw_ms = millis();
int start_ms = 0;
int goal_ms = 0;

void setup(){
  
  myPort = new Serial(this, "/dev/tty.usbmodem411", 9600);
  queue = new ArrayDeque<Integer>();
  
  background(BG_COLOR);
  //size(1366, 768);
  //size(1280, 800);
  //size(1440, 900);
  size(640, 480);
  //size(displayWidth, displayHeight);
  drawTime(0, 0, 0, 0);
  
}

void draw(){

  int ms = millis();
  if(draw_ms + DISPLAY_DELAY_TIME > ms) return;
  draw_ms = ms;
  
  drawTime(time_m, time_s, time_ms, queue.size());
  drawWatch(ms);
  
}

void start_sw(String ms_string){
  println("S");
  int ms = millis();
  if(start_ms + START_DELAY_TIME > ms) return;
  start_ms = ms;
  
  if(ms_string == ""){
    queue.add(millis());
    
  } else {
    int start_ms = int(ms_string);
    queue.add(start_ms);
    println("START" + ms_string);
  }
  //drawTime(time_m, time_s, time_ms, queue.size());
  //drawWatch();
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
    println("GOAL" + goal_ms);
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
  //drawTime(time_m, time_s, time_ms, queue.size());
  //drawWatch();
}

void serialEvent(Serial p) {
  
  String s = p.readStringUntil(10);  
  if (s != null) {
    String data = trim(s);
    String command = data.substring(0, 1);
    String time_val = data.substring(1);
    
    //println(cmd);
    if(command.equals("S")){
      start_sw(time_val);
      //println("start" + val);
      
    } else if(command.equals("G")){
      goal_sw(time_val);
      //println("goal" + val);
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

void drawWatch(int now){

  if(!USE_WATCH) return;
  if(queue.size() < 1) return;
   println(now + " - " + queue.element() + " = " + (now - queue.element()));
   int lms = now - queue.element();
   int ls = lms / 1000;
   int w_time_m = ls / 60;
   int w_time_s = ls % 60;
   int w_time_ms = lms % 1000;
    
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

  //println(nf(time_m, 2) + nf(time_s, 2) + nf(time_ms, 3) + "queue" + nf(running,2) );
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