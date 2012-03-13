// Abstract search class can be extended and logic added for valid neighbors and goal conditions 
// to able to support a wide variety of needs in this project
abstract class Search {
  abstract boolean drawSearch();
  
  private ArrayList<PVector> tracePath(Node finalNode) {
    ArrayList<PVector> path = new ArrayList<PVector>();

    Node current = finalNode;

    while (current.parent != null) {
      path.add(0, current.pos);
      current = current.parent;
    }

    return path;
  }

  public ArrayList<PVector> BFS(int x, int y, int goalX, int goalY) {
    // Use BFS to find closest road piece
    PVector currentPos = new PVector(x, y, 0);
    PVector goal = new PVector(goalX, goalY, 0);
    Node current = new Node(currentPos, null, 0);
    ArrayList<Node> openNodes = new ArrayList<Node>();
    // Use a set as well to track open positions for quick contains check
    Set<PVector> openSet = new HashSet<PVector>();
    Set<PVector> closedSet = new HashSet<PVector>();

    openNodes.add(current);

    while (openNodes.size () > 0) {
      current = openNodes.remove(0);
      openSet.remove(current.pos);
      closedSet.add(current.pos);

      if (goalReached(current, goal)) {
        return tracePath(current);
      }

      for (PVector neighbor : current.neighbors()) {
        if (!openSet.contains(neighbor) && !closedSet.contains(neighbor) && validNeighbor(neighbor)) {
          if (drawSearch()) {
            fill(0, 255, 0, 50);
            stroke(0);
            drawBox(neighbor);
          }
          openNodes.add(new Node(neighbor, current, current.depth + 1));
          openSet.add(neighbor);
        }
      }
    }

    return null;
  }

  abstract boolean goalReached(Node current, PVector goal);

  abstract boolean validNeighbor(PVector potentialNeighbor);
}

class FindNearestRoad extends Search {
  boolean drawSearch() {
    return true;
  }

  boolean goalReached(Node current, PVector goal) {
    return world[int(current.pos.x)][int(current.pos.y)] == ROAD;
  }

  boolean validNeighbor(PVector potentialNeighbor) {
    return world[int(potentialNeighbor.x)][int(potentialNeighbor.y)] != BUILDING;
  }
}

class FindViaRoads extends Search {
  boolean drawSearch() {
    return true;
  }

  boolean goalReached(Node current, PVector goal) {
    return current.pos.x == goal.x && current.pos.y == goal.y;
  }

  boolean validNeighbor(PVector potentialNeighbor) {
    return world[int(potentialNeighbor.x)][int(potentialNeighbor.y)] == ROAD;
  }
}

class FindGoal extends Search {
  boolean drawSearch() {
    return true;
  }

  boolean goalReached(Node current, PVector goal) {
    return current.pos.x == goal.x && current.pos.y == goal.y;
  }

  boolean validNeighbor(PVector potentialNeighbor) {
    return world[int(potentialNeighbor.x)][int(potentialNeighbor.y)] != BUILDING;
  }
}

class FindNearestDevelopment extends Search {
  boolean drawSearch() {
    return false;
  }
  
  boolean goalReached(Node current, PVector goal) {
    return world[int(current.pos.x)][int(current.pos.y)] == BUILDING;
  }

  boolean validNeighbor(PVector potentialNeighbor) {
    return true;
  }
}


