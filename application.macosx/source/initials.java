import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import geomerative.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class initials extends PApplet {

// ConnectedNodes.pde
// Copyright (C) 2011 Fabian "fabiantheblind" Mor\u00f3n Zirfas
// http://www.the-moron.net
// info [at] the - moron . net


NodeSystem ns; // the Systemg
int num = 350; // number of nodes

int Y_AXIS = 1;
int X_AXIS = 2;
int c1, c2, lines;

public void setup() {
  background(0);
  shapeMode(CENTER);
  size(600, 800);
  
  c1 = color(0xffEAEAEA);
  c2 = color(0xffC1A6A6);
  lines = color(0xff3B0505);
  
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


public void draw() {

  // write a rect in the size of the sketch for smooth background clear

  setGradient(0, 0, width, height, c1, c2, Y_AXIS);
  
// run the node system
  ns.run();

//saveFrame("images/nodes-0000.tif");
//noLoop();

}

public void keyPressed(){
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

public void setGradient(int x, int y, float w, float h, int c1, int c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      int c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      int c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}
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
  
  public void set_vel(boolean b){
    vert = b;
  }
  
  public PVector get_pos(){
    return this.pos;
  }
  
  // draw the node
  public void show() { 
    fill(255);
    ellipse(pos.x, pos.y, diam, diam);
  }

  // update the position
  public void update() {
    // Motion 101: Locations changes by velocity.
    if (vert == false){
      pos.add(vel);
      
    } 
  }

  // check Edges makes them come in from the other side
  public void checkEdges() {

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

class NodeSystem {
  
  int connStroke = color(0,0,0);
  
  RShape shp;
  RPoint[] points;
  ArrayList <Node> nodes; // a list of nodes
  float distance; // initial distance
  
  boolean a = false;
  boolean e = false;
  boolean gb = false;
  
  int sparse = 5;
    // constructor 
  NodeSystem(float dis) {
    this.distance = dis;
  }


  // this initalizes the nodes
  public void init(int num) {
    shp = RG.loadShape("aeg.svg");
    shp = RG.centerIn(shp, g, 70);
    shp.translate(width/2.f,height/2.f);
    
    points = shp.getPoints();
    
    
    nodes = new ArrayList();

    // loop thru num
    for (int i = 0; i < num; i++) {
      // make a random point 

      float x = random(10, width - 10);
      float y = random(10, height - 10);
      float r = sqrt((x*x) + (y*y));
      float theta = atan(y / x);


      float diam = 1;// with diameter

      PVector pos = new PVector(x, y);// position into PVector
      Node n = new Node(pos, diam);
      
      nodes.add(n); // add the new node to the list
    }
    
    // make vertices in initials
    float xmod = 0;
    float ymod = 0;
      for(int i=0; i<points.length; i+=sparse){
        float x = points[i].x + xmod;
        float y = points[i].y + ymod;
        float r = sqrt((x*x) + (y*y));
        float theta = atan(y / x);


        float diam = 1;// with diameter

        PVector pos = new PVector(x, y);// position into PVector
        Node n = new Node(pos, diam);
        n.set_vel(true);
        nodes.add(n);
    }
    
  }


  // run the nodesystem
  public void run() {
    display();
  }

  // calculate the connections and draw the lines
  public void calcConnections(Node n) {

    int num = 0; // number of connections

    for (int i = 0; i < nodes.size(); i ++) {

      PVector  v1 = n.pos; // position of reference
      PVector  v2 = nodes.get(i).pos; // every other node
      float d =  PVector.dist(v1, v2);// calc the distance

      // now if the node already has some connections
      // make the diastance he can check higher
      if ((d < distance + n.cons* 1) &&(d > 1)) {

        float opac = random(50, 70);
        stroke(connStroke, opac);
      
      if ((n.vert == false) && (n.cons < 20)){  
        line(v1.x, v1.y, v2.x, v2.y); // draw the line
        num++; // increment num
     }
     }
      // set the connections of the node to the num
      n.cons = num;
    }
  }

  // display the nodes and draw the connections
  public void display() {
    int count = 0;
    Node n = null;// keep it clear

    for (int i = 0; i < nodes.size(); i++) {
      n = nodes.get(i);
      float x = n.pos.x;
      float y = n.pos.y;
      RPoint pt = new RPoint(x,y);
      // call the functions of node
      n.checkEdges(); 
      calcConnections(n);
      
      update_help(n, pt, count);
      
      
      
      n.diam = n.cons/10; // set the size
      //n.show();// display
      
    }
    
  } // end display

public void inc(){
  print("hi");
  float x = random(10, width - 10);
  float y = random(10, height - 10);
  float r = sqrt((x*x) + (y*y));
  float theta = atan(y / x);


  float diam = 1;// with diameter

  PVector pos = new PVector(x, y);// position into PVector
  Node n = new Node(pos, diam); 
  nodes.add(n);
}

public void dec(){
  if(nodes.get(nodes.size() - 1).vert == false){
    nodes.remove(nodes.size() - 1);
  }
}

public void toggle(char ch){
  switch(ch){
    case 'a':
      if (a == false){
      a = true;
    } else {
      a = false;
    }
      break;
    case 'e':
      if (e == false){
        e = true;
      } else {
        e = false;
      }
      break;
    case 'g':
      if (gb == false){
        gb = true;
      } else {
        gb = false;
      }
      break;
  }
 }
 
 public void update_help(Node n, RPoint pt, int count){
   if ((gb == true) || (a == true) || (e == true)){
        if (!shp.contains(pt) || (count > 100)){
          n.update();
      } else {
        count++;
        }
      } else {
        n.update();
   }
 }
 
 public void set_connStroke(int col){
   connStroke = col;
 }
 

}


  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "initials" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
