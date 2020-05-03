class Button {
  String label; 
  float x, y, w, h;
  boolean hover, pressed;
  
  Button(String text, float xpos, float ypos, float width_button, float height_button) {
    label = text;
    x = xpos;
    y = ypos;
    w = width_button;
    h = height_button;
  }
 
  void show() {    
    strokeWeight(1); stroke(0);
    
    if(!hover) fill(218);
    else fill(230);
    rect(x, y, w, h);
    textSize(15);
    textAlign(CENTER, CENTER);
    fill(0);
    text(label, x + (w / 2), y + (h / 2));
    
    hover = false; pressed = false;
    if(mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) hover = true;
    if(mousePressed && hover) pressed = true;
  }
}
 
