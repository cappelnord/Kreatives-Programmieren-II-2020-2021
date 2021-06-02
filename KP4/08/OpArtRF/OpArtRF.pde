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
    
      float hue = i / (float) numCircles + millis() / 1000.0 * 0.25;
    
      fill(hue - floor(hue), 1.0, 1.0);
      
      float displaceX = (mouseX/ (float) width) * 2.0 - 1.0;
      float displaceY = (mouseY/ (float) width) * 2.0 - 1.0;

      float x = width/2 + (displaceX+sin(i*0.4 + millis()/1000.0 * 4)*400);
      float y = height/2 +(displaceY+sin(i*0.333 + millis()/1000.0 * 3.33)*333);
      
      // fill(i % 2 * 255);
      circle(x, y, width - (width / numCircles) * i);
  }
}
