int gridScale = 10;
int cols, rows;

void setup() {
  size(500, 500);

  cols = width/gridScale;
  rows = height/gridScale;
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

void draw() {
  drawGrid();
}

