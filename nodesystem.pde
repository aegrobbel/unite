class NodeSystem {

  color connStroke = color(0, 0, 0);
  RFont ft;
  
  RShape shp;
  RPoint[] points;
  ArrayList <Node> nodes; // a list of nodes
  float distance; // initial distance

  boolean a = false;
  boolean e = false;
  boolean gb = false;
  boolean space = false;

  int sparse = 5;
  
  // constructor 
  NodeSystem(float dis) {
    this.distance = dis;
  }


  // this initalizes the nodes
  void init(int num) {
    
    shp = RG.getText("UNITE","Consolas.ttf", 350, CENTER);
//    shp = RG.loadShape("aeg.svg");
    shp = RG.centerIn(shp, g, 70);
//    shp.scale(0.8);
    shp.translate(width/2., height/2.);

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
    for (int i=0; i<points.length; i+=sparse) {
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
  void run() {
    display();
  }

  // calculate the connections and draw the lines
  void calcConnections(Node n) {

    int num = 0; // number of connections

    for (int i = 0; i < nodes.size (); i ++) {

      PVector  v1 = n.pos; // position of reference
      PVector  v2 = nodes.get(i).pos; // every other node
      float d =  PVector.dist(v1, v2);// calc the distance

      // anow if the node already has some connections
      // make the diastance he can check higher
      if ((d < distance + n.cons* 1) &&(d > 1)) {

        float opac = random(40, 70);
        stroke(connStroke, opac);

        if ((n.vert == false) && (n.cons < 10)) {  
          line(v1.x, v1.y, v2.x, v2.y); // draw the line
          num++; // increment num
        }
      }
      // set the connections of the node to the num
      n.cons = num;
    }
  }

  // display the nodes and draw the connections
  void display() {
    int count = 0;
    Node n = null;// keep it clear

    for (int i = 0; i < nodes.size (); i++) {
      n = nodes.get(i);
      float x = n.pos.x;
      float y = n.pos.y;
      RPoint pt = new RPoint(x, y);
      // call the functions of node
      n.checkEdges(); 
      calcConnections(n);

      update_help(n, pt, count);



      n.diam = n.cons/10; // set the size
//      n.show();// display
    }
  } // end display

  void inc() {
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

  void dec() {
    if (nodes.get(nodes.size() - 1).vert == false) {
      nodes.remove(nodes.size() - 1);
    }
  }

  void toggle(char ch) {
    switch(ch) {
    case '1':
      if (a == false) {
        a = true;
        e = false;
        gb = false;
        space = false;
        print("a switched to true!");
      } else {
        a = false;
        print("a switched to false!");
      }
      break;
    case '2':
      if (e == false) {
        e = true;
        a = false;
        gb = false;
        space = false;
        print("e switched to true!");
      } else {
        e = false;
        print("e switched to false!");
      }
      break;
    case ' ':
      if (space == false) {
        space = true;
        a = false;
        e = false;
        gb = false;
        print("space switched to true!");
      } else {
        space = false;
        print("space switched to false!");
      }
      break;
    case '3':
      if (gb == false) {
        gb = true;
        a = false;
        e = false;
        space = false;
        print("g switched to true!");
      } else {
        gb = false;
        print("g switched to false!");
      }
      break;
    }
  }

  void update_help(Node n, RPoint pt, int count) {
    if (space == true) {
      if (!shp.contains(pt) || (count > 100) || (in_mouse(n) == true)) {
        n.update();
      }
    } else if (a == true) {
      if (!shp.children[0].contains(pt) || (count > 100) || (in_mouse(n) == true)) {
        n.update();
      }
    } else if (e == true) {
      if (!shp.children[1].contains(pt) || (count > 100) || (in_mouse(n) == true)) {
        n.update();
      }
    } else if (gb == true) {
      if (!shp.children[2].contains(pt) || (count > 100) || (in_mouse(n) == true)) {
        n.update();
      }
    } else {
      count++;
      n.update();
    }
  }

  void set_connStroke(color col) {
    connStroke = col;
  }
}

boolean in_mouse(Node n){
  int x = int(n.pos.x);
  int y = int(n.pos.y);
  if ((x < mouseX + 25) && (x > mouseX - 25)) {
    if ((y < mouseY + 25) && (y > mouseY - 25)) {
      return true;
    }
  }
  return false;
}
