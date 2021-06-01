float x, y;
float rectAngle;
int count = 0;
float angle, amp, freq;


void setup(){
  size(800, 800);
  background(0);
  frameRate(60);
  //x = width / 2;
  x = 0;
  y = height / 2;
  angle = 0;
  amp = 200;
  
}

void draw(){
  
  scale(0.5); // Vorbereitung für nächstes Mal
  translate(width / 2, height / 2); 
  
  //background(0);
  stroke(0,0,255, 30);
  noFill();
  sineLines(10);
  
  stroke(0,255,0, 100);
  sineCircles(2);
  
  // Je nachdem wo wir die eraser Funktion ausführen, wirkt sich deren Rotation
  // und Translation auch auf nachfolgende Zeichnungen aus !
  // Dazu machen wir nächstes Mal noch ein paar Beispiele...
  
  eraser(0.01 * 2); // Die selbe Frequenz wie unsere sineCircles
  
  stroke(255,0,0, 100);
  strokeWeight(1);
  sineLines(10);
  
  // Unser Framecount;
  count++; // => count = count + 1;
  if(count >= 60){
    count = 0;
  }
}


void sineCircles(int freq){
  
  for (int i = 0; i <= width / 2.5; i++){
    x = i * 5 - width / 2;
    angle += 0.01;
    // Y Abhängig von Random:
    y = height / 2 + random(50.0); 
    // Y Abhängig von einer SinusFunktion
    y = height / 2 + sin(TWO_PI * angle * freq) * amp ; // TWO_PI => 2 * PI
    
    // Wir Wollen das Line Bündel nach Rechts verschieben
    circle(x,y, 5);
  }
}

void sineLines(int freq){
  
  for (int i = 0; i <= width / 10; i++){
    x = i * 10;
    angle += 0.01;
    // Y Abhängig von Random:
    // y = height / 2 + random(50.0); 
    // Y Abhängig von einer SinusFunktion
    y = height / 2 + sin(TWO_PI * angle * freq) * amp ; // TWO_PI => 2 * PI
    
    // Wir Wollen das Line Bündel nach Rechts verschieben
    line(x,y, width / 2 + count * 10, height / 2);
  }
}

void eraser(float speed){
  
  rectAngle += speed;
  translate(width / 2, height / 2); // Verschiebung zurück in die Mitte
  rotate(TWO_PI * rectAngle); // Rotation von speed
  noStroke();
  fill(0,0,0, 100);
  rect(0, 0 , width / 2, height);
  if(rectAngle >= width){
    rectAngle = 0;
  }
}
