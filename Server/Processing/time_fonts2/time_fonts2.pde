//show time sample
import processing.serial.*;
Serial myPort;

import java.util.Queue;
import java.util.ArrayDeque;
Queue<Integer> queue;

String FONT_NAME = "Osaka";
int FONT_COLOR = #FFFFFF;
int BG_COLOR = #000000;
boolean DEBUG = true;
boolean USE_WATCH = true;
boolean USE_MOUSE = false;

int time_m = 0;
int time_s = 0;
int time_ms = 0;

int start;
int goal;
int millisecond;
int rend_time;
int second;

void setup(){
  background(BG_COLOR);
  //size(1366, 768);
  //size(1280, 800);
  //size(1440, 900);
  size(640, 480);
  //size(displayWidth, displayHeight);
  drawTime(0, 0, 0, 0);
  queue = new ArrayDeque<Integer>();
  myPort = new Serial(this, "/dev/tty.usbmodem411", 9600);
}


void draw(){
  drawTime(time_m, time_s, time_ms, queue.size());
  if(USE_WATCH){
    
    //int ms = millis();
    
    //if(ms - rend_time > 80){
    //  rend_time = ms;
    //  if(queue.size() > 0){
    //    start = queue.element();
    //    goal = ms;
    //    drawWatch();
    //  }
    //}
  }
}

void start_s(String ms_string){
  if(ms_string == ""){
    queue.add(millis());
  } else {
    int l_ms = int(ms_string);
    queue.add(l_ms);
    //println("START" + l_ms);
  }
  //drawTime(time_m, time_s, time_ms, queue.size());
  //drawWatch();
}

void goal_s(String ms_string){
  
  if(ms_string == ""){
    goal = millis();
  } else {
    int l_ms = int(ms_string);
    goal = int(l_ms);
    //println("GOAL" + l_ms);
  }
  
  try{
    start = queue.remove();
    millisecond = goal - start;
    second = millisecond / 1000;
    
    //if(DEBUG){
    //  println("start:" + str(start));
    //  println("goal:" + str(goal));
    //  println("realtime:" + str(millisecond));
    //}
    
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
    String t = trim(s);
    String cmd = t.substring(0, 1);
    String val = t.substring(1);
    
    //println(cmd);
    if(cmd.equals("S")){
      start_s(val);
      //println("start" + val);
      
    } else if(cmd.equals("G")){
      goal_s(val);
      //println("goal" + val);
    }
  }
}

void mousePressed(){
  
  if(!USE_MOUSE) return;
  
  switch(mouseButton){
    case LEFT: //START
      start_s("");
      delay(100);
      break;
    
    case RIGHT: //GOAL 
      goal_s("");
      delay(100);
      break;
  }
}

//void drawWatch(){

//    millisecond = goal - start;
//    second = millisecond / 1000;
//    int w_time_m = second / 60;
//    int w_time_s = second % 60;
//    int w_time_ms = millisecond % 1000;
    
//    fill(0,0,0);
//    rect(
//    20,
//    height / 1.4,
//    250,
//    250
//    );
   
//    fill(255,255,255);
//    textAlign(LEFT);
//    int fontSize = height / 18;
//    PFont fn2 = createFont(FONT_NAME, fontSize);
//    textFont(fn2);
//    text(
//       nf(w_time_m, 2) + ":" + nf(w_time_s, 2) + "." + nf(w_time_ms, 3),
//       20,
//       height / 1.2
//     );
 
//}

void drawTime(int time_m, int time_s, int time_ms, int running){
  background(#000000);

  println(nf(time_m, 2) + nf(time_s, 2) + nf(time_ms, 3) + "queue" + nf(running,2) );
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