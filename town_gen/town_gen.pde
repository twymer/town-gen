import java.util.Queue;

int gridScale = 5;
int cols = 100;
int rows = 100;
ArrayList<Building> buildings;
int world[][] = new int[cols][rows];
ExtenderAgent extender = new ExtenderAgent();
ConnectorAgent connector = new ConnectorAgent();

int roadServicedDistance = 5;
int maxExtenderDistance = 10;
int connectorDistance = 10;

boolean extend = true;

// No enums in processing
public static final int EMPTY = 0;
public static final int ROAD = 1;
public static final int BUILDING = 2;

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

void drawBox(int x, int y) {
  rect(x * gridScale, y * gridScale, gridScale, gridScale);
}

void drawBox(PVector pos) {
  drawBox(int(pos.x), int(pos.y));
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

void keyPressed() {
  extend = !extend;
}

void draw() {
  background(255);
  // This method is very framerate intensive
  //drawGrid();

  drawWorld();

  if(extend) {
    extender.update();
  }
  connector.update();
}

