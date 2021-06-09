PImage img;

void setup() {
  background(0);
  size(700, 700);
  img = loadImage("rocks.jpeg"); 
}

void draw() {

  image(img, 0, 0);
  loadPixels();
  
  for (int i = 0; i < width * height; i++) {
    if (i < pixelWidth * pixelHeight - 1){
      pixels[i]  += pixels[i + 1] * 10;
    } 
  }
  updatePixels();
}
  
