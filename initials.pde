// ConnectedNodes.pde
// Copyright (C) 2011 Fabian "fabiantheblind" Morón Zirfas
// http://www.the-moron.net
// info [at] the - moron . net
import geomerative.*;
NodeSystem ns; // the Systemg
NodeSystem bg;

int num = 700; // number of nodes
int numbg = 100;
boolean record;

int Y_AXIS = 1;
int X_AXIS = 2; 
color c1, c2, lines, linesbg;

void setup() {
  background(0);
  shapeMode(CENTER);
  size(800, 600);

  c1 = color(#FFF5F5);
  c2 = color(#554142);
  lines = color(#000000);
  linesbg = color(#333333);

  // the starting distance for the calculation of the lines
  int distance = 42;
  int distancebg = 42;
  // create the NodeSystem with distance
  ns = new NodeSystem(distance);
  
  bg = new NodeSystem(distancebg);

  // initials, load library
  // VERY IMPORTANT: Allways initialize the library before using it
  RG.init(this);


  frameRate(15);
  smooth(); // make it smooth
  ns.init(num);
  ns.set_connStroke(lines);
  
  bg.init(numbg);
  bg.set_connStroke(linesbg);
}// end of setup


void draw() {

  // write a rect in the size of the sketch for smooth background clear

  setGradient(0, 0, width, height, c1, c2, Y_AXIS);

  // run the node system
  ns.run();
  bg.run();
  //noLoop();
  if (record) {
    saveFrame("images/nodes-######.tif");
    record = false;
  }
}// end draw

void keyPressed() {
  if (keyPressed == true) {
    if (key == '1') {
      ns.toggle('1');
    } 
    if (key == '2') {
      ns.toggle('2');
    }
    if (key == '3') {
      ns.toggle('3');
    }
    if (key == ' ') {
      ns.toggle(' ');
    }
    if (keyCode == UP) {
      ns.inc();
    }
    if (keyCode == DOWN) {
      ns.dec();
    }
    if (key == 'q') {
      exit();
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
  } else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}

// Use a keypress so thousands of files aren't created
void mousePressed() {
  record = true;
}
