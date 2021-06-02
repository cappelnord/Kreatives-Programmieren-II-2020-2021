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
      
      float x = width/2 + sin(i * 0.2 + millis() / 1000.0 * 4.0) * 40.0;
      float y = height/2;
      
      // fill(i % 2 * 255);
      circle(x, y, width - (width / numCircles) * i);
  }
}
