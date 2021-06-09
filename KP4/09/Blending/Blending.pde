PImage pilz;
PImage mask;
PImage rinde;
PImage headphones;

void setup() {
  size(800, 800);
  pilz = loadImage("pilz.png");
  mask = loadImage("mask.png");
  rinde = loadImage("rinde.jpg");
  headphones = loadImage("headphones.png");
}

void draw() {
  noStroke();
  
  blendMode(BLEND);
  background(255);
  blendMode(SUBTRACT);
  tint(255, 0, 0);
  image(pilz, sin(frameCount * 0.02) * 50.0, 0, width, height);
  tint(0, 255, 0);
  image(pilz, sin(frameCount* 0.011) * 50.0, 0, width, height);
  tint(0, 0, 255);
  image(pilz, 0, 0, width, height);

  blendMode(BLEND);
  
  fill(255, 200, 50, 200);
  circle(width/2, height/2, 200);
  
  blendMode(SUBTRACT);

  tint(128, 128, 128);
  image(rinde, 0, 0, width, height);
  
    
  blendMode(ADD);
  
  tint(255, 0, 0);
  image(headphones, 0, 0, width, height);
  

  blendMode(MULTIPLY);
  
  tint(255, 255, 255);
  image(mask, 0, 0, width, height);
  
  saveFrame("frames/####.jpg");
}

void keyPressed() {
}
