import java.util.Queue;

int gridScale = 5;
int cols = 100;
int rows = 100;

int startX = int(cols / 2);
int startY = int(rows / 2);

int world[][] = new int[cols][rows];

Agent extender = new ExtenderAgent();
Agent extender2 = new ExtenderAgent();
Agent extender3 = new ExtenderAgent();

Agent connector = new ConnectorAgent();
Agent connector2 = new ConnectorAgent();
Agent connector3 = new ConnectorAgent();
Agent connector4 = new ConnectorAgent();

Agent builder = new BuildingAgent();

// Used for saving an image
ArrayList<RoadSegment> roads = new ArrayList<RoadSegment>();
ArrayList<Building> buildings = new ArrayList<Building>();

// Poorly placed config values for agents
int roadServicedDistance = 5;
int maxExtenderDistance = 10;
int connectorDistance = 10;
int maxDistanceFromDevelopment = 20;
int builderSearchDistance = 3;

// Used to toggle updating of agents
boolean extend = true;

// Used to do post execution drawing
boolean prettyDraw = false;

// When false, only one agent of each type will run at once
boolean multipleAgents = true;

// No enums in processing
public static final int EMPTY = 0;
public static final int ROAD = 1;
public static final int BUILDING = 2;

void addRoad(ArrayList<PVector> path) {
  ArrayList<PVector> road = new ArrayList<PVector>();
  for (PVector p : path) {
    world[int(p.x)][int(p.y)] = ROAD;
    road.add(p);
  }
  roads.add(new RoadSegment(road));
}

void setup() {
  frameRate(600);
  size(cols * gridScale, rows * gridScale);

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      world[i][j] = EMPTY;
    }
  }

  // Road seed point
  world[startX][startY] = ROAD;
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

void drawWorld() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (world[i][j] != EMPTY) {
        int x = i*gridScale;
        int y = j*gridScale;

        if (world[i][j] == ROAD) {
          stroke(0, 40);
          fill(0);
        } 
        else if (world[i][j] == BUILDING) {
          stroke(0);

          fill(255, 165, 0);
        }

        rect(x, y, gridScale, gridScale);
      }
    }
  }
}

void keyPressed() {
  if (key == 'e' || key == 'E') {
    extend = !extend;
  } else if(key == 'p' || key == 'P') {
    extend = false;
    prettyDraw = true;
  }
}

void draw() {
  background(255);
  // This method is very framerate intensive
  //drawGrid();

  if(prettyDraw) {
    for(RoadSegment rs : roads) {
      rs.drawSegment();
    }
    
    for(Building b : buildings) {
      b.drawBuilding();
    }
  } else {
    drawWorld();
  }

  if (extend) {
    extender.update();
    connector.update();
    builder.update();

    if (multipleAgents) {
      extender2.update();
      extender3.update();
      connector2.update();
      connector3.update();
      connector4.update();
    }
  }
}

