long ms;
long b_ms;
long ms_start = 0;
long ms_goal = 0;

long switch_delay_ms = 1500;
long delay_ms = 280;

void setup() {
  Serial.begin(9600);

  pinMode(10, INPUT);
  pinMode(11, INPUT);

}

void loop() {
  ms = millis();
  String time_string = String(ms);
  if(digitalRead(10) == 1){
    //START
    if(ms > ms_start + switch_delay_ms){ 
      Serial.println("S" + time_string);
      ms_start = ms;
    }
    
  }
  
  if(digitalRead(11) == 1){
    //GOAL
    if(ms > ms_goal + switch_delay_ms){
      Serial.println("G" + time_string);
      ms_goal = ms;
    }
  }

  if(ms > b_ms + delay_ms){
    Serial.println("T" + time_string);
    b_ms = ms;
  }

}
