int numCircles = 16;

color frontColor = color(0, 0, 0);
color backColor = color(255, 255, 255);

void setup() {
  size(800, 800, P3D);
  
  frameRate(60);
  smooth();
}

void draw() {
  background(backColor);
  // background(255, 255, 255);
  // stroke(frontColor);
  noStroke();
  
  for(int i = 0; i < numCircles; i++) {
      if(i % 2 == 0) {
        fill(frontColor);
      } else {
        fill(backColor);
      }
      
      float displaceX = (mouseX / (float) width) * 2.0  - 1.0;
      float displaceY = (mouseY / (float) height) * 2.0  - 1.0;
      
      float x = width/2 + (displaceX * 50 * i);
      float y = height/2 + (displaceY * 50 * i);
      
      // fill(i % 2 * 255);
      circle(x, y, width - (width / numCircles) * i);
  }
}
