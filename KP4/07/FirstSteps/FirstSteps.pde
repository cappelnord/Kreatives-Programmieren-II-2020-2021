// Processing: Java
// C, C++, C#, ... 

// Typen
int x = 300;
int y = 100;

// int: Ganzzahlen
// float: Gleitkommazahlen
float apfel = 1.3;

// String: Zeichenkeitten
String name = "Patrick";

// Auch Funktionen müssen einen Rückgabewert haben
int mult(int a, int b) {
  return a * b;
}

void setup() {
  size(500, 500);
}

void draw() {
  
  // background(0, 0, 0);
  background(0);
  
  //   R    G  B
  fill(255, 0, 0);
  
  stroke(0, 255, 0);
  strokeWeight(20);
  noStroke();
  
  //     X   Y    Radius
  circle(x, mouseY, 50);
  
  x = x - 2;
}
