abstract class Agent {
  int xPos, yPos;

  protected boolean validWorldCoordinates(int x, int y) {
    if (x > 0 && x < cols && y > 0 && y < rows) {
      return true;
    } 
    else {
      return false;
    }
  }

  protected boolean validWorldCoordinates(float x, float y) {
    return validWorldCoordinates(int(x), int(y));
  }

  abstract void update();
}

class ConnectorAgent extends Agent {
  ArrayList<PVector> directions = new ArrayList<PVector>();

  private PVector findNearbyRoadSegment() {
    noFill();
    rect((-connectorDistance + xPos) * gridScale, (-connectorDistance + yPos) * gridScale, 
          2 * connectorDistance * gridScale, 2 * connectorDistance * gridScale);
    ArrayList<PVector> nearbyRoads = new ArrayList<PVector>();
    for (int i = -connectorDistance; i < connectorDistance; i++) {
      for (int j = -connectorDistance; j < connectorDistance; j++) {
        if (validWorldCoordinates(i + xPos, j + yPos) &&
          (i != 0 || j != 0) && 
          world[i + xPos][j + yPos] == ROAD) {
          nearbyRoads.add(new PVector(i + xPos, j + yPos, 0));
        }
      }
    }
    Collections.shuffle(nearbyRoads);

    if (nearbyRoads.size() > 0) {
      line(xPos * gridScale, yPos * gridScale, nearbyRoads.get(0).x * gridScale, nearbyRoads.get(0).y * gridScale);
      return nearbyRoads.get(0);
    } 
    else {
      return null;
    }
  }

  public void update() {
    Collections.shuffle(directions);

    for (PVector dir : directions) {
      if (validWorldCoordinates(xPos + dir.x, yPos + dir.y) &&
        world[int(xPos + dir.x)][int(yPos + dir.y)] == ROAD) {
        xPos += dir.x;
        yPos += dir.y;
        break;
      }
    }

    PVector nearby = findNearbyRoadSegment();
    
    if (nearby != null) {
      fill(255, 255, 0);
      ellipse(xPos * gridScale, yPos * gridScale, 15, 15);
  
      Search s = new FindViaRoads();
      ArrayList<PVector> path = s.BFS(xPos, yPos, int(nearby.x), int(nearby.y));
      
      int worldDist = int(sqrt(sq(nearby.x - xPos) + sq(nearby.y - yPos)));
      if(path.size() > worldDist * 2) {
        s = new FindGoal();
        path = s.BFS(xPos, yPos, int(nearby.x), int(nearby.y));
        addRoad(path);
      }
      //println("dist: " + worldDist);
      //if(path != null) { println("pathdist: " + path.size()); }
    }

    fill(255, 0, 0);
    stroke(0);
    ellipse(xPos * gridScale, yPos * gridScale, 15, 15);
    //drawBox(xPos, yPos);
  }

  ConnectorAgent() {
    // Initialize list of possible directions
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        directions.add(new PVector(i, j, 0));
      }
    }

    // These values need to be the initial road seed position
    xPos = int(cols / 2);
    yPos = int(rows / 2);
  }
}

class ExtenderAgent extends Agent {
  // Count how any pixels of road are in the square surrounding
  private int roadCountInRange(int squareRadius) {
    int count = 0;
    for (int i = -squareRadius; i < squareRadius; i++) {
      for (int j = -squareRadius; j < squareRadius; j++) {
        if (validWorldCoordinates( i + xPos, j + yPos) &&
          world[i + xPos][j + yPos] == ROAD) {
          count++;
        }
      }
    }

    return count;
  }

  private boolean useRoadSegment(ArrayList<PVector> path) {
    if (path == null) { 
      return false;
    }

    if (roadCountInRange(maxExtenderDistance) > 3) {
      return false;
    }

    return true;
  }

  public void update() {
    Search s = new FindNearestRoad();
    ArrayList<PVector> result = s.BFS(xPos, yPos, 0, 0);

    if (useRoadSegment(result)) {
      addRoad(result);
    }

    int xDir = round(random(-1, 1));
    int yDir = round(random(-1, 1));

    // Don't move if out of bounds, skipping a move or two
    // when on the border shouldn't be a problem
    if (validWorldCoordinates(xPos + xDir, yPos + yDir)) {
      xPos += xDir;
      yPos += yDir;
    }

    fill(0, 0, 255);
    stroke(0);
    drawBox(xPos, yPos);
  }

  ExtenderAgent() {
    xPos = int(cols / 2);
    yPos = int(rows / 2);
  }
}

