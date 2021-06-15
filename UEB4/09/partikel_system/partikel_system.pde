//Particle p;
ParticleSystem ps;
ArrayList<ParticleSystem> pList;

void setup(){
  size(700,700);
  background(0);
  //p = new Particle(new PVector(width / 2, 100));
  pList = new ArrayList<ParticleSystem>();
}

void draw(){
  background(0);
  
  for(int i = 0; i < pList.size(); i++){
    ps = pList.get(i);
    ps.run();
  }
  //Maximale Anzahl an lebenden Partikeln:
  //print(pList.size() * 256 + "//");
}

void mouseClicked(){
  
  // Wir instantiieren ein neues Partikelsystem und tragen es in unser pList ein
  // Innerhalb der ParicleSystem Class wird dann mouseX und mouseY an die gespwanten Partikel weitergegeben
  ps = new ParticleSystem(new PVector(mouseX, mouseY));
  pList.add(ps);
}

class ParticleSystem{
  
  ArrayList<Particle> particles;
  PVector spawn;
  
  ParticleSystem(PVector pos){
    // .copy() nicht vergessen, so stellen wir sicher, dass die Usprungsposition immer ein neuer Wert / Neue Kopie ist ! 
    spawn = pos.copy();
    particles = new ArrayList<Particle>();
  }
  
  void run(){
    particles.add(new Particle(spawn));
    for (int i = 0; i < particles.size(); i++){
      Particle p = particles.get(i);
      p.update();
      p.display();
      // print(particles.size()); 
      // Unser Garbage Collector removed alle nicht mehr sichtbaren Partikel aus der Partikel-Liste
      if(p.lifetime < 0){
        particles.remove(i);
      }
    }
  }
}

class Particle{
  
  PVector position;
  float lifetime, radius, xVelo, yVelo, drag, r,g;
  
  Particle(PVector pos){
    position = pos.copy();
    lifetime = 255;
    xVelo = random(-3, 3); 
    yVelo = random(-0.5, 3);
    radius = random(1, 25);
    r = random(0,255);
    g = random(0,50);
  }
   
  void update(){
    position.y += yVelo ;
    position.x += xVelo;
    lifetime--;
  }
  
  void display(){
    noStroke();
    fill(r, g,255, lifetime);
    circle(position.x, position.y, radius); 
  }
}
