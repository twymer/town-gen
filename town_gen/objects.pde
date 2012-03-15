class RoadSegment {
  ArrayList<PVector> roadPoints;
  
  public void drawSegment() {
    fill(0);
    stroke(0);
    strokeWeight(5);
    beginShape(LINE);
    for(PVector p : roadPoints) {
      vertex(p.x * gridScale, p.y * gridScale);
    }
    endShape();
    strokeWeight(1);
  }
  
  RoadSegment(ArrayList<PVector> pts) {
    roadPoints = pts;
  }
}

class Building {
  ArrayList<PVector> buildingPoints;
  
  public void drawBuilding() {
    fill(random(0, 255), random(0, 255), random(0, 255));
    stroke(0);
    
    // Find the corner points to make a square
    PVector l = buildingPoints.get(0);
    PVector t = buildingPoints.get(0);
    PVector r = buildingPoints.get(0);
    PVector b = buildingPoints.get(0);
    
    for(PVector p: buildingPoints) {
      if(p.x < l.x) { l = p; }
      if(p.x > r.x) { r = p; }
      if(p.y < b.y) { b = p; }
      if(p.y > t.y) { t = p; }
    }
    
    if((t.x == l.x && t.y == l.y) ||
       (t.x == r.x && t.y == r.y)) {
         return;
     }
    quad(l.x * gridScale, l.y * gridScale,
         t.x * gridScale, t.y * gridScale,
         r.x * gridScale, r.y * gridScale,
         b.x * gridScale, b.y * gridScale);
  }
  
  Building(ArrayList<PVector> pts) {
    buildingPoints = pts;
  }
}
