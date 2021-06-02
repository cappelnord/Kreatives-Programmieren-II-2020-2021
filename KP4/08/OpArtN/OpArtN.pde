int numCircles = 16;

color frontColor = color(0, 0, 0);
color backColor = color(255, 255, 255);

void setup() {
  size(800, 800);
  
  frameRate(60);
  smooth();
}

void draw() {
  background(backColor);
  // background(255, 255, 255);
  noStroke();
  
  for(int i = 0; i < numCircles; i++) {
      if(i % 2 == 0) {
        fill(255-(i*30), 255-(i*20), 255);
      } else {
        fill(0+(i*30), i*20, 0);
      }
      
      float displaceX = (mouseX / (float) width-sin(i*0.02)) * 2.0  - 1.0;
      float displaceY = (mouseY / (float) height+sin(i*0.01)) * 2.0  - 1.0;
      
      float x = width/2 + (displaceX * 50 * sin(i));
      float y = height/2 + (displaceY * 50 * cos(i));
      
      // fill(i % 2 * 255);
      circle(x, y, width - (width / numCircles) * i);
  }
}
