int gridScale = 10;
int cols, rows;
ArrayList<Building> buildings;


class Building {
  String name;
  int xSize, ySize;
  float userImportance;
  float townImportance;
  int xPos, yPos;
  
  Building(String n, int x, int y, float user, float town) {
    name = n;
    xSize = x;
    ySize = y;
    userImportance = user;
    townImportance = town;
  }
}

void setup() {
  size(500, 500);

  cols = width/gridScale;
  rows = height/gridScale;
  
  buildings = new ArrayList<Building>();
  buildings.add(new Building("Armory", 4, 4, 1, .5));
  buildings.add(new Building("Alchemist", 3, 3, 1, .2));
  buildings.add(new Building("General Store", 3, 3, .8, 1));
}

void drawGrid() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {

      int x = i*gridScale;
      int y = j*gridScale;
      fill(255);
      stroke(0, 50);

      rect(x, y, gridScale, gridScale);
    }
  }
}

void drawBuilding(Building b) {
  fill(0);
  noStroke();
  rect(0, 0, b.xSize * gridScale, b.ySize * gridScale);
}

void drawBuildings() {
  for(Building b : buildings) {
    drawBuilding(b);
  }
}

void draw() {
  drawGrid();
  
  drawBuildings();
}

