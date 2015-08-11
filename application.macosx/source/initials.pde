// ConnectedNodes.pde
// Copyright (C) 2011 Fabian "fabiantheblind" Morón Zirfas
// http://www.the-moron.net
// info [at] the - moron . net

import geomerative.*;
NodeSystem ns; // the Systemg
int num = 350; // number of nodes

int Y_AXIS = 1;
int X_AXIS = 2;
color c1, c2, lines;

void setup() {
  background(0);
  shapeMode(CENTER);
  size(600, 800);
  
  c1 = color(#EAEAEA);
  c2 = color(#C1A6A6);
  lines = color(#3B0505);
  
  // the starting distance for the calculation of the lines
  int distance = 42;
  // create the NodeSystem with distance
  ns = new NodeSystem(distance);

  // initials, load library
   // VERY IMPORTANT: Allways initialize the library before using it
  RG.init(this);
  
  
  frameRate(15);
  smooth(); // make it smooth
  // initalise all the nodes
  // if you put the init into the draw it calcs every loop new nodes
  ns.init(num);
  ns.set_connStroke(lines);
  
}// end of setup


void draw() {

  // write a rect in the size of the sketch for smooth background clear

  setGradient(0, 0, width, height, c1, c2, Y_AXIS);
  
// run the node system
  ns.run();

//saveFrame("images/nodes-0000.tif");
//noLoop();

}

void keyPressed(){
  if (keyPressed == true){
    if (key == 'a'){
      ns.toggle('a');
    } else if (key == 'e'){
      ns.toggle('e');
    } else if (key == 'g'){
      ns.toggle('g');
    } else if (keyCode == UP){
      ns.inc();
    } else if (keyCode == DOWN){
      ns.dec();
    }
  }
}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}
