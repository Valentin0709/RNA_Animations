class Particle{
  PVector pos, velocity, acceleration; //position, velocity, acceleration\
  int radius = 50, text_size = 30;
  String text;
  
  Particle(String t) {
    text = t;
    pos = new PVector(random(x0, xn), random(y0, yn));
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }
  
  Particle(int x, int y) {
    pos = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }
  
  Particle(String t, int x, int y) {
    text = t;
    pos = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }
  
  void update() {
   // velocity.add(acceleration);
    pos.add(acceleration);
    acceleration.x = 0; acceleration.y = 0;
    
    if(pos.x < x0) pos.x = x0 + 10;
    if(pos.y < y0) pos.y = y0 + 10;
    if(pos.x > xn) pos.x = xn - 10;
    if(pos.y > yn) pos.y = yn - 10;
   }
  
  void show() {
    strokeWeight(5);
    stroke(41, 47, 54); fill(247, 255, 247);
    circle(pos.x, pos.y, radius);
    
    fill(0);
    PFont font = createFont("Arial Black", text_size);
    textFont(font);
    textAlign(CENTER, CENTER);
    text(text, pos.x - radius/2, pos.y - radius/2 - 5, radius, radius);
  }
  
  void show(int x, int y) {
    strokeWeight(5);
    stroke(41, 47, 54); fill(247, 255, 247);
    circle(x, y, radius);
    
    fill(0);
    PFont font = createFont("Arial Black", text_size);
    textFont(font);
    textAlign(CENTER, CENTER);
    text(text, x - radius/2, y - radius/2 - 5, radius, radius);
  }
  
  void show(color c) {
    strokeWeight(6);
    stroke(0); fill(c);
    circle(pos.x, pos.y, radius);
    
    fill(0);
    PFont font = createFont("Arial Black", text_size);
    textFont(font);
    textAlign(CENTER, CENTER);
    text(text, pos.x - radius/2,  pos.y - radius/2 - 5, radius, radius);
  }
}
