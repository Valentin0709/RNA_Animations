int min_distance = 100;

class RNA {
  int RNA_size;
  int number_bps;
  String[] code = new String[100];
  base_pair[] bp = new base_pair[100];
  Particle[] particle_list;
  color highlight_color = color(255, 230, 109);
  int highlight_paticle;
  
  RNA(int s) {
    RNA_size = s;
    particle_list = new Particle[s];
    highlight_paticle = -1;
    
    number_bps = int(random(s/6, s/4)); //number of base pairs in the RNA molecule
    
    //decide how the bases pair
    int[] bp_order = new int[number_bps];
    bp_order = generate_pairing(number_bps);
    
    //decide which positions participate in base pairing
    IntList bp_position = new IntList();
    for(int i = 1; i <= number_bps * 2; i++) {
      bp_position.append(1);
    }
    for(int i = 1; i <= RNA_size - number_bps * 2; i++) {
      bp_position.append(0);
    }
    while(!valid_sequence(bp_position, bp_order)) bp_position.shuffle();
    
    //generate the RNA sequence
    LinkedList<Integer> l = new LinkedList<Integer>();
    int order_index = 0, bp_index = 0;
    for(int i = 0; i < RNA_size; i++) {
      if(bp_position.get(i) == 0) code[i] = random_base();
      else {
        if(bp_order[order_index] == 0) {
          code[i] = random_base();
          l.add(i);
        }
        else {
          int pair_pos = l.pollLast();
          code[i] = complementary_base(code[pair_pos]);
          
          bp[bp_index] = new base_pair(0, 0);
          bp[bp_index].pos1 = i;
          bp[bp_index].pos2 = pair_pos;
          bp_index++;
        }
     
        order_index++;
      }
    }
    
    //create particles
    for(int i = 0; i < RNA_size; i++) particle_list[i] = new Particle(code[i]);

  }
  
  void dynamic_folding() {
    simulate_interactions(4800, 1200);
  }
  
  void animate() {
    simulate_interactions(1600, 800);
  }
  
  void simulate_interactions(int attraction_coefficient, int repulsion_coefficient) {
    //chain interaction
    for(int i = 0; i < RNA_size - 1; i++) {
      attraction(particle_list[i], particle_list[i + 1], attraction_coefficient);
      for(int j = i + 1; j < RNA_size; j++) repulsion(particle_list[i], particle_list[j], repulsion_coefficient);
    }  
    
    //base pair interaction
    for(int i = 0; i < number_bps; i++) attraction(particle_list[bp[i].pos1], particle_list[bp[i].pos2], attraction_coefficient);
    
    //edge interaction 
    for(int i = 0; i < RNA_size; i++) {
      particle_list[i].acceleration.add(PVector.sub(particle_list[i].pos, new PVector(particle_list[i].pos.x, y0)).setMag(2000/pow(particle_list[i].pos.y, 2))); //north edge
      particle_list[i].acceleration.add(PVector.sub(particle_list[i].pos, new PVector(particle_list[i].pos.x, yn)).setMag(2000/pow((yn - particle_list[i].pos.y), 2))); //south edge
      particle_list[i].acceleration.add(PVector.sub(particle_list[i].pos, new PVector(x0, particle_list[i].pos.y)).setMag(2000/pow(particle_list[i].pos.x, 2))); //west edge
      particle_list[i].acceleration.add(PVector.sub(particle_list[i].pos, new PVector(xn, particle_list[i].pos.y)).setMag(2000/pow((xn - particle_list[i].pos.x), 2))); //east edge
    }
     
     for(int i = 0; i < RNA_size; i++) particle_list[i].update();
  }
 
  
  void show() {
    noFill(); 
    stroke(41, 47, 54); strokeWeight(10);
    beginShape();
    curveVertex(particle_list[0].pos.x, particle_list[0].pos.y);
    for(int i = 0; i < RNA_size; i++) {
      curveVertex(particle_list[i].pos.x, particle_list[i].pos.y);
    }
    curveVertex(particle_list[RNA_size - 1].pos.x, particle_list[RNA_size - 1].pos.y);
    endShape();
    
    stroke(187, 68, 48);
    for(int i = 0; i < number_bps; i++) dashed_line(particle_list[bp[i].pos1].pos.x, particle_list[bp[i].pos1].pos.y, particle_list[bp[i].pos2].pos.x, particle_list[bp[i].pos2].pos.y);
    
    for(int i = 0; i < RNA_size; i++) particle_list[i].show();
    if(highlight_paticle != -1) particle_list[highlight_paticle].show(highlight_color);
  }
  
  void show_seq(int x) {    
    highlight_paticle = x;
    
    boolean oktip = false;
    for(int i = 0; i < number_bps; i++) {
      if(bp[i].pos1 == x) {last_text = " ) "; oktip = true; break;}
      if(bp[i].pos2 == x) {last_text = " ( "; oktip = true; break;}
    }
    if(!oktip) last_text = " . ";
  }
  
  void show_sketch() {    
    
    //for(int i = 0; i < number_bps; i++) dashed_line(particle_list[bp[i].pos1].pos.x, particle_list[bp[i].pos1].pos.y, particle_list[bp[i].pos2].pos.x, particle_list[bp[i].pos2].pos.y);
    stroke(41, 47, 54); strokeWeight(10);
    line(50, 500, 50 + (RNA_size - 1) *60, 500);
    
    char[] t = new char[RNA_size];
    for(int i = 0; i < RNA_size; i++) t[i] = '.';
    
    stroke(187, 68, 48);
    for(int i = 0; i < number_bps; i++) {
      t[bp[i].pos2] = '('; t[bp[i].pos1] = ')';
      
      line(50 + bp[i].pos2 * 60, 500, 50 + bp[i].pos2 * 60, 500 - (bp[i].pos1 - bp[i].pos2 + 1) * 15);
      line(50 + bp[i].pos2 * 60, 500 - (bp[i].pos1 - bp[i].pos2 + 1) * 15, 50 + bp[i].pos1 * 60, 500 - (bp[i].pos1 - bp[i].pos2 + 1) * 15);
      line(50 + bp[i].pos1 * 60, 500 - (bp[i].pos1 - bp[i].pos2 + 1) * 15, 50 + bp[i].pos1 * 60, 500);
    }
    
    for(int i = 0; i < RNA_size; i++) particle_list[i].show(50 + i * 60, 500);
    for(int i = 0; i < RNA_size; i++) {
      fill(0);
      PFont font = createFont("Arial Black", 30);
      textFont(font);
      textAlign(CENTER, CENTER);
      text(t[i], 50 + i * 60, 550);
    }
  }
}

class base_pair {
  int pos1, pos2;
  
  base_pair(int x, int y) {
    pos1 = x;
    pos2 = y;
  }
}

int[] generate_pairing(int number_pairs) {
  int[] solution = new int[number_pairs * 2];
  int open_pairs = 0, close_pairs = 0;
  
  for(int i = 0; i < number_pairs * 2; i++) {
    if(open_pairs < number_pairs) {
      if(close_pairs < open_pairs) {
        float element = random(0, 1);
        if(element <= 0.5) {
          open_pairs++;
          solution[i] = 0;
        }
        else {
          close_pairs++;
          solution[i] = 1;
        }
      }
      else {
        open_pairs++;
        solution[i] = 0;
      }
    }
    else {
      close_pairs++;
      solution[i] = 1;
    }
  }
  
  return solution;
}

String random_base() {
  float base = random(0, 1);

  if(base < 0.25) return "U";
  if(base >= 0.25 && base < 0.50) return "A";
  if(base >= 0.50 && base < 0.75) return "C";
  if(base >= 0.75) return "G";
  
  return "N";
 }
 
 String complementary_base(String c) {
   if(c == "U") return "A";
   if(c == "A") return "U";
   if(c == "C") return "G";
   if(c == "G") return "C";
   
   return "N";
 }

 void attraction(Particle p1, Particle p2, int c) {
    float distance = dist(p1.pos.x, p1.pos.y, p2.pos.x, p2.pos.y);
    if(distance >= min_distance) {
      p1.acceleration.add(PVector.sub(p2.pos, p1.pos).setMag(c/distance));
      p2.acceleration.add(PVector.sub(p1.pos, p2.pos).setMag(c/distance));
    }

 }
 
  void repulsion(Particle p1, Particle p2, int c) {
    float distance = dist(p1.pos.x, p1.pos.y, p2.pos.x, p2.pos.y);
    p1.acceleration.add(PVector.sub(p1.pos, p2.pos).setMag(c/pow(distance, 2)));
    p2.acceleration.add(PVector.sub(p2.pos, p1.pos).setMag(c/pow(distance, 2)));

 }
 
 boolean valid_sequence(IntList pos, int[] order) {
   int index_bp = 0;
   for(int i = 0; i < pos.size(); i++) {
     if(pos.get(i) == 1) {
       if(index_bp > 0 && pos.get(i - 1) == 1 && order[index_bp - 1] == 0 && order[index_bp] == 1) return false;
       index_bp++;
     }
   }
   return true;
 }
 
 void dashed_line(float x1, float y1, float x2, float y2) {
   for (int i = 0; i <= 8; i++) {
      float x = lerp(x1, x2, i/8.0);
      float y = lerp(y1, y2, i/8.0);
      point(x, y);
    }
 }
