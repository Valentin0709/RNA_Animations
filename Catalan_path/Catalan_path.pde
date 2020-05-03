import java.util.LinkedList;

PVector rabbit, final_point, initial_point;
PImage rabbit_img, carrot_img, grass_img;
int[] sol = new int[100];
int l = 5, nseq = 0, nshow = 0, step = 0, count = 0;
int square_length = 150, xpos = 100, ypos = 100;
int[][] seq = new int[1000][100];
boolean oka = false, okrec = false, oks = false;
String path = "";

Button snap_button = new Button("Snap", 1100, 660, 100, 30);
Button record_button = new Button("Record", 1100, 700, 100, 30);
Button norecord_button = new Button("No Record", 1100, 740, 100, 30);
Button start_button = new Button("Start", 1100, 620, 100, 30);

void setup() {
 size(1400, 950);
 
 rabbit_img =  loadImage("rabbit.png");
 carrot_img =  loadImage("carrot.png");
 grass_img =  loadImage("grass.png");
 
 rabbit = new PVector(xpos, ypos + l * square_length);
 final_point = new PVector(xpos, ypos + l * square_length);
 initial_point = new PVector(xpos, ypos + l * square_length);
 
 bkt(0);
}

void draw() {
  background(168, 212, 173);
  
  snap_button.show();
  record_button.show();
  norecord_button.show();
  start_button.show();
  
  show_grid();
     
  
 if(oks && nshow < nseq) {
      
      PFont font = createFont("Arial Black", 35);
      textFont(font);
      textAlign(LEFT, CENTER);
      text("Path Number " + (nshow + 1), 100, 60);
      text(path, 80, 900);
    
    if(rabbit.x == final_point.x && rabbit.y == final_point.y) {
      if(step == 2 * l) {
        step = 0; nshow++;
        rabbit.x = xpos; rabbit.y = ypos + l * square_length;
        initial_point.x = xpos; initial_point.y = ypos + l * square_length;
        final_point.x = xpos; final_point.y = ypos + l * square_length;
        delay(500);
        
        path = "";
      }
      else {
        initial_point = final_point.copy();
        if(seq[nshow][step] == 0) {
          final_point.x += square_length;
          path += "right ";
        }
        else {
          final_point.y -= square_length;
          path += "up ";
        }
        step++;
        
      }
    }
    else {
      rabbit.x += (final_point.x - initial_point.x);
      rabbit.y += (final_point.y - initial_point.y);
      
      strokeWeight(15); stroke(232, 95, 92);
      line(initial_point.x, initial_point.y, rabbit.x, rabbit.y);
    }
    
      PVector path = new PVector(xpos, ypos + l * square_length);
      strokeWeight(15); stroke(232, 95, 92);
      for(int i = 0; i < step - 1; i++) {
        if(seq[nshow][i] == 0) {
          line(path.x, path.y, path.x + square_length, path.y);
          path.x += square_length;
        }
        else {
          line(path.x, path.y, path.x, path.y - square_length);
          path.y -= square_length;
        }
    }
    }
  
  image(rabbit_img, rabbit.x - 75, rabbit.y - 75, 150, 150);
  
  if(snap_button.pressed) {
     PImage partialSave = get(25,25,1050,1050);
     partialSave.save("images/image.jpg");
  }
  if(record_button.pressed) {okrec = true; oks = true;}
  if(norecord_button.pressed) okrec = false;
  if(start_button.pressed) oks = true;
  
  if(okrec) {
     PImage partialSave = get(0,0,950,950);
     partialSave.save("images/animation" + count + ".jpg");
     count++;
   }
}

void show_grid() {
  strokeWeight(6); stroke(0);
  for(int i = 0; i <= l; i++) {
    line(xpos + i * square_length, ypos, xpos + i * square_length, ypos + l * square_length);
    line(xpos, ypos + i * square_length, xpos + l * square_length, ypos + i * square_length);
  }
  
  //fence
  strokeWeight(15); stroke(150 ,125, 105);
  line(xpos, ypos + 5 * square_length, xpos + 5 * square_length, ypos);
  
  image(grass_img, 110, 110, 90, 75);
  image(grass_img, 420, 560, 90, 75);
  image(grass_img, 850, 750, 90, 75);
  image(grass_img, 750, 300, 90, 75);
  image(grass_img, 100, 430, 90, 75);
  image(carrot_img, xpos + l * square_length - 38, ypos - 75, 75, 150);

}

void bkt(int n) {
  for(int i = 0; i <= 1; i++) {
    sol[n] = i;
    if(n == 2 * l - 1) {
      if(valid()) {
        for(int j = 1; j < 2 * l; j++) seq[nseq][j] = sol[j];
        nseq++;
      }
    }
    else bkt(n + 1);
  }
}

boolean valid() {
  int nr0 = 0;
  
  for(int i = 0; i < 2 * l; i++) {
    if(sol[i] == 0) nr0++;
    else nr0--;
    
    if(nr0 < 0) return false;
  }
  
  if(nr0 == 0) return true;
  return false;
}
