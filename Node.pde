// the node class holds the only the points
// the lines get caculated in the NodeSystem

class Node {

  boolean vert;
  
  PVector pos; // the node position
  PVector vel; // the velocity of the node
  float diam; // the diameter
  int cons = 0; // the connection he has

  // the constructor
  Node(PVector pos, float diam) {
    this.pos = pos;
    this.diam = diam;
    // start with own velocity
    vel = new PVector(random(-2, 2), random(-2, 2));
  }
  
  void set_vel(boolean b){
    vert = b;
  }
  
  PVector get_pos(){
    return this.pos;
  }
  
  // draw the node
  void show() { 
    fill(255);
    ellipse(pos.x, pos.y, diam, diam);
  }

  // update the position
  void update() {
    // Motion 101: Locations changes by velocity.
    if (vert == false){
      pos.add(vel);
      
    } 
  }

  // check Edges makes them come in from the other side
  void checkEdges() {

    if (pos.x > width) {
      pos.x = 0;
    } else if (pos.x < 0) {
      pos.x = width;
    } // X

    if (pos.y > height) {
      pos.y = 0;
    } else if (pos.y < 0) {
      pos.y = height;
    }// Y
  }// end checkEdges

}

