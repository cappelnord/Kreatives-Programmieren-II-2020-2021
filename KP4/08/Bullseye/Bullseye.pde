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
  // stroke(frontColor);
  noStroke();
  
  for(int i = 0; i < numCircles; i++) {
      if(i % 2 == 0) {
        fill(frontColor);
      } else {
        fill(backColor);
      }
      
      // fill(i % 2 * 255);
      circle(width/2, height/2, width - (width / numCircles) * i);
  }
}
