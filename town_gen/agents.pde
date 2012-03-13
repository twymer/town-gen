abstract class Agent {
  int xPos, yPos;

  // Store list of possible directions an agent could move  
  ArrayList<PVector> directions = new ArrayList<PVector>();


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

  Agent() {
    // Initialize list of possible directions
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        directions.add(new PVector(i, j, 0));
      }
    }
  }
}

class ConnectorAgent extends Agent {
  private PVector findNearbyRoadSegment() {
    noFill();
    stroke(0, 55);
    rect((-connectorDistance + xPos) * gridScale, (-connectorDistance + yPos) * gridScale, 
    2 * connectorDistance * gridScale, 2 * connectorDistance * gridScale);

    // Collect nearby road segments and shuffle them      
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
      noFill();
      stroke(0);
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
      if (path.size() > worldDist * 2) {
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
    // These values need to be the initial road seed position
    xPos = startX;
    yPos = startY;
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

  private boolean tooFar(int x, int y) {
    Search s = new FindNearestDevelopment();

    ArrayList<PVector> path = s.BFS(x, y, 0, 0);
    //println(path);
    if (path == null) {
      return sqrt(sq(x - startX) + sq(y - startY)) > maxDistanceFromDevelopment;
    } 
    else {
      return path.size() > maxDistanceFromDevelopment;
    }
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
    if (validWorldCoordinates(xPos + xDir, yPos + yDir) && !tooFar(xPos + xDir, yPos + yDir)) {
      xPos += xDir;
      yPos += yDir;
    }

    fill(0, 0, 255);
    stroke(0);
    drawBox(xPos, yPos);
  }

  ExtenderAgent() {
    xPos = startX;
    yPos = startY;
  }
}

class BuildingAgent extends Agent {
  private ArrayList<PVector> suggestBuilding(PVector startPos) {

    ArrayList<PVector> buildingPieces = new ArrayList<PVector>();
    buildingPieces.add(startPos);

    //    PVector topRight = new PVector(1, 1);
    //    PVector topLeft = new PVector(-1, 1);
    //    PVector bottomRight = new PVector(1, -1);
    //    PVector bottomLeft = new PVector(-1, -1);
    ArrayList<PVector> dirs = new ArrayList<PVector>();
    dirs.add(new PVector(1, 1));
    dirs.add(new PVector(-1, 1));
    dirs.add(new PVector(1, -1));
    dirs.add(new PVector(-1, -1));

    Search s = new FindNearestDevelopment();

    // Expand on random edges until building is sufficiently large
    while (buildingPieces.size () < 10 && dirs.size() > 1) {
      boolean failed = false;
      ArrayList<PVector> newPieces = new ArrayList<PVector>();

      // Shuffle remaining available directions before choosing to
      // help buildings spread evenly
      Collections.shuffle(dirs);      
      PVector d = dirs.get(0);


      // For each piece in the building, try to see if the neighbor in this direction is 
      for (PVector p : buildingPieces) {
        PVector temp = new PVector(p.x, p.y);
        temp.add(d);
        //println("p: " + p);
        //println("temp: " + temp);

        if (!buildingPieces.contains(temp)) {
          if (validWorldCoordinates(int(temp.x), int(temp.y)) &&
            world[int(temp.x)][int(temp.y)] != ROAD &&
            world[int(temp.x)][int(temp.y)] != BUILDING) {
            ArrayList<PVector> path = s.BFS(int(temp.x), int(temp.y), 0, 0);
            println(path);
            if (path == null || (path.size() > 3 || buildingPieces.contains(path.get(path.size() - 1)))) {
              newPieces.add(temp);
            } 
            else {
              failed = true;
              dirs.remove(0);
              break;
            }
          } 
          else {
            failed = true;
            dirs.remove(0);
            break;
          }
        }
      }
      if (!failed) {
        buildingPieces.addAll(newPieces);
      }
    }

    println("returning: " + buildingPieces.size() + " pieces");

    return buildingPieces;
  }

  private void addBuildingToWorld(ArrayList<PVector> building) {
    for (PVector p : building) {
      world[int(p.x)][int(p.y)] = BUILDING;
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

    // Pick a random nearby non developed, non road area by collecting all
    // and shuffling
    ArrayList<PVector> nearbyLand = new ArrayList<PVector>();
    for (int i = -builderSearchDistance; i < builderSearchDistance; i++) {
      for (int j = -builderSearchDistance; j < builderSearchDistance; j++) {
        if (validWorldCoordinates(i + xPos, j + yPos) &&
          (i != 0 || j != 0) && 
          world[i + xPos][j + yPos] != ROAD &&
          world[i + xPos][j + yPos] != BUILDING) {
          nearbyLand.add(new PVector(i + xPos, j + yPos, 0));
        }
      }
    }
    Collections.shuffle(nearbyLand);

    if (!nearbyLand.isEmpty()) {
      ArrayList<PVector> building = suggestBuilding(nearbyLand.get(0));
      if (building.size() > 2) {
        //random(0, 1) > .95) {
        addBuildingToWorld(building);
      }
    }

    fill(0, 255, 0);
    stroke(0);
    ellipse(xPos * gridScale, yPos * gridScale, 15, 15);
  }

  BuildingAgent() {
    xPos = startX;
    yPos = startY;
  }
}

