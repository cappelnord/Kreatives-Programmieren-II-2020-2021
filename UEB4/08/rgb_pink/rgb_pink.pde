float rot = 0.0;

void setup(){
  size(700,700);
  background(0);
}

void draw(){
  translate(width / 2, height / 2);
  scale(2);
  scale(rot % 1);
  noStroke();
  rotate(PI + rot);
  
  
  fill(255,0,0, 50);
  rect(0, 0, 20, 20);  // Red rectangle
  
  pushMatrix();
  rotate(PI + rot);
  translate(30, 20);
  pushMatrix();
  translate(50,50);
  fill(255,0,255, 50);  
  rect(0, 0, 20, 20);  // Pink rectangle
  popMatrix();
  fill(0,255,0, 50);  
  rect(0, 0, 20, 20);  // Green rectangle
  popMatrix();
  
  
  fill(0,0,255, 50);  
  rect(15, 10, 20, 20);  // Blue rectangle
  
  rot += 0.2;
}
