import java.util.LinkedList;

RNA r;
int x0 = 50, y0 = 50, xn = 1000, yn = 750, nseq, lnseq, timer, count = 0;
boolean okr = false, okf = false, oks = false, oka = false, okrec = false, oksk = false;;
String bottom_text = "", last_text = "";

Button gen_button = new Button("Generate", 10, 10, 100, 30);
Button start_button = new Button("Start", 120, 10, 100, 30);
Button stop_button = new Button("Stop", 230, 10, 100, 30);
Button seq_button = new Button("Seq", 340, 10, 50, 30);
Button animate_button = new Button("Animate", 400, 10, 100, 30);
Button delete_button = new Button("Delete", 510, 10, 100, 30);
Button record_button = new Button("Record", 620, 10, 100, 30);
Button norecord_button = new Button("No Record", 730, 10, 100, 30);
Button auto_button = new Button("Auto", 840, 10, 100, 30);
Button sketch_button = new Button("Shetck", 950, 10, 100, 30);
Button snap_button = new Button("Snap", 1060, 10, 100, 30);

void setup(){
  size(1900, 800);
  frameRate(60);
}
 
void draw(){
  background(149, 217, 218);
  
   gen_button.show();
   start_button.show();
   stop_button.show();
   seq_button.show();
   animate_button.show();
   delete_button.show();
   record_button.show();
   norecord_button.show();
   auto_button.show();
   sketch_button.show();
   snap_button.show();
   
   fill(0);
   PFont font = createFont("Arial Black", 30);
   textFont(font);
   textAlign(LEFT, CENTER);
   text(bottom_text, 50, 750);
   fill(255, 230, 109);
   text(last_text, 50 + textWidth(bottom_text), 750);
   
   if(gen_button.pressed) {
     r = new RNA(30);
     okr = true; okf = false; oksk = false;
   }
   if(start_button.pressed) {oka = false; okf = true;}
   if(stop_button.pressed) okf = false;
   if(record_button.pressed) okrec = true;
   if(norecord_button.pressed) okrec = false;
   if(animate_button.pressed) {oka = true; okf = false;}
   if(seq_button.pressed) {
       oks = true; nseq = 0; lnseq = -1; timer = millis();
       bottom_text = ""; last_text = "";
    }
   if(delete_button.pressed) bottom_text = "";
   if(auto_button.pressed) {
     okrec = true; okf = false; oka = true;
     oks = true; nseq = 0; lnseq = -1; timer = millis();
     bottom_text = ""; 
   }
   if(sketch_button.pressed) {
     oksk = true; 
     okf = false; oka = false; okr = false;
   }
   
   if(okr) r.show();  
   if(oksk)r.show_sketch();
   if(okf) r.dynamic_folding();
   if(oka) r.animate();
   if(oks && timer + nseq * 750 <=  millis() && nseq != lnseq) {
     lnseq = nseq;
     if(nseq < r.RNA_size) {bottom_text += last_text;  last_text = ""; r.show_seq(nseq);}
     if(nseq > r.RNA_size) {oks = false; r.highlight_paticle = -1; }
     nseq++; 
   }
   if(oks == false) {okrec = false; bottom_text = ""; last_text = "";}
   if(okrec) {
     PImage partialSave = get(50,50,950,750);
     partialSave.save("images/animation" + count + ".jpg");
     count++;
   }
   
   if(snap_button.pressed) {
     PImage partialSave = get(50,50,950,750);
     partialSave.save("images/image.jpg");
   }
}
