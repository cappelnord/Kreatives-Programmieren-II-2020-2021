int numCircles = 16;

color frontColor = color(0, 0, 0);
color backColor = color(255, 255, 255);

color[] colors = new color[numCircles];

void setup() {
  size(800, 800, P3D);
  
  frameRate(60);
  smooth();

}

void draw() {
  background(backColor);
  noStroke();
  
  colorMode(HSB, 1.0, 0.8, 1.0);
  
  for(int i = 0; i < numCircles; i++) {
    
      fill(i / (float) numCircles + millis() / 1000.0, 1.0, 1.0);

      float x = width/2;
      float y = height/2;
      
      // fill(i % 2 * 255);
      circle(x, y, width - (width / numCircles) * i);
  }
}
