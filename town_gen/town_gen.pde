import java.util.Queue;

int gridScale = 5;
int cols = 100;
int rows = 100;
ArrayList<Building> buildings;
int world[][] = new int[cols][rows];
ExtenderAgent extender = new ExtenderAgent();

int roadServicedDistance = 5;
int maxExtenderDistance = 5;

// No enums in processing
public static final int EMPTY = 0;
public static final int ROAD = 1;
public static final int BUILDING = 2;

class Building {
  String name;
  int xSize, ySize;
  float userImportance;
  float townImportance;
  int xPos, yPos;

  void setXPos(int newPos) {
    xPos = newPos;
  }

  void setYPos(int newPos) {
    yPos = newPos;
  }

  void setPos(int x, int y) {
    xPos = x;
    yPos = y;
  }

  Building(String n, int x, int y, float user, float town) {
    name = n;
    xSize = x;
    ySize = y;
    userImportance = user;
    townImportance = town;
  }
}

class Node {
  PVector pos;
  Node parent;
  int depth;

  Node(PVector location, Node p, int d) {
    pos = location;
    parent = p;
    depth = d;
  }

  public ArrayList<PVector> neighbors() {
    ArrayList<PVector> neighbors = new ArrayList<PVector>();
    //PVector newNode = new P
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        PVector newNode = new PVector(this.pos.x + i, this.pos.y + j);
        if (newNode.x > 0 && newNode.x < cols && newNode.y > 0 && newNode.y < rows) {
          neighbors.add(newNode);
        }
      }
    }
    return neighbors;
  }
}

class ExtenderAgent {
  int xPos, yPos;

  private boolean useRoadSegment(ArrayList<PVector> path) {
    if (path == null) { 
      return false;
    }

    return true;
  }

  public void update() {
    ArrayList<PVector> result = findClosestRoad(xPos, yPos);

    if (useRoadSegment(result)) {
      addRoad(result);
    }
    
    xPos = int(random(0, cols));
    yPos = int(random(0, rows));
  }
    //    xPos++;
    //    if (xPos >= cols) {
    //      xPos = 0;
    //      yPos++;
    //    }
    //    if (yPos >= rows) {
    //      yPos = 0;
    //    }
    //  }

  ExtenderAgent() {
    xPos = 25;
    yPos = 45;
    //xPos = int(cols / 2);
    //yPos = int(rows / 2);
  }
}

ArrayList<PVector> tracePath(Node finalNode) {
  ArrayList<PVector> path = new ArrayList<PVector>();

  Node current = finalNode;

  while (current.parent != null) {
    path.add(0, current.pos);
    current = current.parent;
  }

  return path;
}

ArrayList<PVector> findClosestRoad(int x, int y) {
  // Use BFS to find closest road piece
  PVector currentPos = new PVector(x, y, 0);
  Node current = new Node(currentPos, null, 0);
  ArrayList<Node> openNodes = new ArrayList<Node>();
  // Use a set as well to track open positions for quick contains check
  Set<PVector> openSet = new HashSet<PVector>();
  Set<PVector> closedSet = new HashSet<PVector>();

  openNodes.add(current);

  while (openNodes.size () > 0) {
    //println(openNodes.size());
    current = openNodes.remove(0);
    openSet.remove(current.pos);
    closedSet.add(current.pos);

    if (world[int(current.pos.x)][int(current.pos.y)] == ROAD) {
      return tracePath(current);
    }

    for (PVector neighbor : current.neighbors()) {
      if (!openSet.contains(neighbor) && !closedSet.contains(neighbor) && current.depth + 1 < maxExtenderDistance) {
        //println("Added neighbor: " + neighbor);
        drawBox(neighbor);
        openNodes.add(new Node(neighbor, current, current.depth + 1));
        openSet.add(neighbor);
      } 
    }
  }

  return null;
}

void addRoad(ArrayList<PVector> path) {
  for (PVector p : path) {
    world[int(p.x)][int(p.y)] = ROAD;
  }
}

void setup() {
  frameRate(60);
  size(cols * gridScale, rows * gridScale);

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      world[i][j] = EMPTY;
    }
  }

  buildings = new ArrayList<Building>();
  buildings.add(new Building("Armory", 4, 4, 1, .5));
  buildings.get(buildings.size() - 1).setPos(2, 2);
  buildings.add(new Building("Alchemist", 3, 3, 1, .2));
  buildings.get(buildings.size() - 1).setPos(20, 2);
  buildings.add(new Building("General Store", 3, 3, .8, 1));
  buildings.get(buildings.size() - 1).setPos(2, 20);

  // Road seed point
  world[int(cols / 2)][int(rows / 2)] = ROAD;
}

void drawGrid() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {

      int x = i*gridScale;
      int y = j*gridScale;
      fill(255);
      stroke(0, 10);

      rect(x, y, gridScale, gridScale);
    }
  }
}

void drawBox(PVector pos) {
  fill(0, 255, 0);
  stroke(0);
  rect(pos.x * gridScale, pos.y * gridScale, gridScale, gridScale);
}

void drawBuilding(Building b) {
  fill(0);
  noStroke();
  rect(b.xPos * gridScale, b.yPos * gridScale, b.xSize * gridScale, b.ySize * gridScale);
}

void drawBuildings() {
  for (Building b : buildings) {
    drawBuilding(b);
  }
}

void drawWorld() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (world[i][j] != EMPTY) {
        int x = i*gridScale;
        int y = j*gridScale;
        if (world[i][j] == ROAD) {
          fill(0);
          stroke(0, 40);
        } 
        else if (world[i][j] == BUILDING) {
          fill(255, 200, 200);
          stroke(0, 80);
        }
        rect(x, y, gridScale, gridScale);
      }
    }
  }
}

void draw() {
  background(255);
  // This method is very framerate intensive
  //drawGrid();

  drawWorld();

  extender.update();
}

