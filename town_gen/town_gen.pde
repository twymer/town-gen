int gridScale = 5;
int cols = 100;
int rows = 100;
ArrayList<Building> buildings;
int world[][] = new int[cols][rows];

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

void setup() {
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
        } else if (world[i][j] == BUILDING) {
          fill(255, 200, 200);
          stroke(0, 80);
        }
        rect(x, y, gridScale, gridScale);
      }
    }
  }
}

void draw() {
  drawGrid();

  drawWorld();

  //drawBuildings();
}

