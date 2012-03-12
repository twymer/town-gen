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
