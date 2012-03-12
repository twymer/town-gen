class Node {
  PVector pos;
  Node parent;
  int depth;

  Node(PVector location, Node p, int d) {
    pos = location;
    parent = p;
    depth = d;
  }

  protected boolean validWorldCoordinates(int x, int y) {
    if (x > 0 && x < cols && y > 0 && y < rows) {
      return true;
    } 
    else {
      return false;
    }
  }

  public ArrayList<PVector> neighbors() {
    ArrayList<PVector> neighbors = new ArrayList<PVector>();
    //PVector newNode = new P
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        PVector newNode = new PVector(this.pos.x + i, this.pos.y + j);
        if (validWorldCoordinates(int(newNode.x), int(newNode.y))) {
          neighbors.add(newNode);
        }
      }
    }
    return neighbors;
  }
}
