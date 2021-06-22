import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress SC;
int startX = 0, startY = 0;
int g = 0;

void setup(){
  size(700,700);
  background(0);
  oscP5 = new OscP5(this, 12000);
  SC = new NetAddress("127.0.0.1", 57120);
}

void draw(){
  //background(0);
  stroke(255, g, 255, 150);
  line(startX, startY, width / 2, height / 2);
}

void oscEvent(OscMessage message){
  // message.get() funktioniert in der Regel nicht ohne TypeCast !
  startX = message.get(0).intValue();
  startY = message.get(1).intValue();
  g = message.get(2).intValue();
  //print(startX, startY);
  OscMessage outMessage = new OscMessage("/sc");
  outMessage.add(10);
  // Hiermit können wir unserem Sketch etwas mehr Zeit geben
  delay(100);
  
  oscP5.send(outMessage, SC); 
  }
