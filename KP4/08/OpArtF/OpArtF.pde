int numCircles = 16;

color frontColor = color(0, 0, 0);
color backColor = color(255, 255, 255);

color[] colors = new color[numCircles];

void setup() {
  size(800, 800, P3D);
  
  frameRate(60);
  smooth();
  
  for(int i = 0; i < numCircles; i++) {
    colors[i] = color(random(255), random(0), random(50));
  }
}

void draw() {
  background(backColor);
  noStroke();

  randomSeed(1230);
  
  for(int i = 0; i < numCircles; i++) {
      fill(colors[i]);

      float x = width/2 + sin(i * 0.2 + millis() / 1000.0 * 4.0) * 40.0;
      float y = height/2;
      
      // fill(i % 2 * 255);
      circle(x, y, width - (width / numCircles) * i);
  }
}
