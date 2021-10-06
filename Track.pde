class Track {

    int spaces = 6;
    int gridSize;
    ArrayList<Square> squares;
    int offset;
    int buf;
    ArrayList<Boundary> walls;
    ArrayList<Checkpoint> points;
    
    int tSeg = 5;

    Track() {
        gridSize = height / spaces;
        squares = new ArrayList<Square>();
        offset = gridSize / 4;
        buf = offset / 2;
        walls = new ArrayList<Boundary>();

        //squares.add(new Square(gridSize, 0, 2, 0, 1 , false));
        //squares.add(new Square(gridSize, 0, 1, 0, 2 , false));
        //squares.add(new Square(gridSize, 0, 0, 2, 3 , true, true));
        //squares.add(new Square(gridSize, 1, 0, 3, 4 , true, true));
        //squares.add(new Square(gridSize, 1, 1, 1, 5 , true, false));
        //squares.add(new Square(gridSize, 2, 1, 0, 6 , true, false));
        //squares.add(new Square(gridSize, 2, 0, 2, 7 , true, true));
        //squares.add(new Square(gridSize, 3, 0, 3, 8 , true, true));
        //squares.add(new Square(gridSize, 3, 1, 2, 9 , false));
        //squares.add(new Square(gridSize, 3, 2, 2, 10, false));
        //squares.add(new Square(gridSize, 3, 3, 0, 11, true, true));
        //squares.add(new Square(gridSize, 2, 3, 1, 12, true, true));
        //squares.add(new Square(gridSize, 2, 2, 3, 13, true, false));
        //squares.add(new Square(gridSize, 1, 2, 2, 14, true, false));
        //squares.add(new Square(gridSize, 1, 3, 0, 15, true, true));
        //squares.add(new Square(gridSize, 0, 3, 1, 16, true, true));
        
        squares.add(new Square(gridSize, 0, 4, 0, 1 , false));
        squares.add(new Square(gridSize, 0, 3, 0, 2 , false));
        squares.add(new Square(gridSize, 0, 2, 2, 3 , true, true));
        squares.add(new Square(gridSize, 1, 2, 0, 4 , true, false));
        squares.add(new Square(gridSize, 1, 1, 0, 5 , false));
        squares.add(new Square(gridSize, 1, 0, 2, 6 , true, true));
        squares.add(new Square(gridSize, 2, 0, 1, 7 , false));
        squares.add(new Square(gridSize, 3, 0, 3, 8 , true, true));
        squares.add(new Square(gridSize, 3, 1, 0, 9 , true, true));
        squares.add(new Square(gridSize, 2, 1, 2, 10, true, false));
        squares.add(new Square(gridSize, 2, 2, 2, 11, false));
        squares.add(new Square(gridSize, 2, 3, 1, 12, true, false));
        squares.add(new Square(gridSize, 3, 3, 1, 13, false));
        squares.add(new Square(gridSize, 4, 3, 0, 14, true, false));
        squares.add(new Square(gridSize, 4, 2, 0, 15, false));
        squares.add(new Square(gridSize, 4, 1, 2, 16, true, true));
        squares.add(new Square(gridSize, 5, 1, 3, 17, true, true));
        squares.add(new Square(gridSize, 5, 2, 2, 18, false));
        squares.add(new Square(gridSize, 5, 3, 2, 19, false));
        squares.add(new Square(gridSize, 5, 4, 2, 20, false));
        squares.add(new Square(gridSize, 5, 5, 0, 21, true, true));
        squares.add(new Square(gridSize, 4, 5, 1, 22, true, true));
        squares.add(new Square(gridSize, 4, 4, 3, 23, true, false));
        squares.add(new Square(gridSize, 3, 4, 3, 24, false));
        squares.add(new Square(gridSize, 2, 4, 2, 25, true, false));
        squares.add(new Square(gridSize, 2, 5, 0, 26, true, true));
        squares.add(new Square(gridSize, 1, 5, 3, 27, false));
        squares.add(new Square(gridSize, 0, 5, 1, 28, true, true));
        
        
        for (Square s : squares) {
            genWalls(s);   
        }
    }

    void show() {
        stroke(255, 100);
        strokeWeight(1);
        for (int i = 1; i <= spaces; i++) {
            line(i * gridSize, 0, i * gridSize, height);
            line(0, i * gridSize, height, i * gridSize);
        }

        for (Boundary b : walls) {
            b.show();
        }
    }
    
    void genWalls(Square s) {
        if (!s.turn) {
            addStraight(s.x, s.y, (s.rotation == 1 || s.rotation == 3)); 
        } else {
            addTurn(s.x, s.y, s.rotation);   
        }
    }
    
    void genPoints(Square s) {
       
    }

    void addStraight(int x, int y, boolean horizontal) {
        int xPos = x * gridSize;
        int yPos = y * gridSize;
        if (horizontal) {
            walls.add(new Boundary(xPos, yPos + offset, xPos + gridSize, yPos + offset));
            walls.add(new Boundary(xPos, yPos + gridSize - offset, xPos + gridSize, yPos + gridSize - offset));
        } else {
            walls.add(new Boundary(xPos + offset, yPos, xPos + offset, yPos + gridSize));
            walls.add(new Boundary(xPos + gridSize - offset, yPos, xPos + gridSize - offset, yPos + gridSize));
        }
    }

    void addTurn(int x, int y, int rotation) {
        int cx;
        int cy;
        int rSmall = offset / 2;
        int rBig = gridSize - (3 * offset / 2);
        int deg = 90 / tSeg;
        int angleOff = rotation * 90;
        switch (rotation) {
        case 0:
            cx = x * gridSize + offset / 2;
            cy = y * gridSize + offset / 2;
            top(x, y); 
            left(x, y);  
            break;
        case 1:
            cx = (x + 1) * gridSize - offset / 2;
            cy = y * gridSize + offset / 2;
            top(x, y);
            right(x, y);
            break;
        case 2:
            cx = (x + 1) * gridSize - offset / 2;
            cy = (y + 1) * gridSize - offset / 2;
            right(x, y);
            bottom(x, y);
            break;
        case 3:
            cx = x * gridSize + offset / 2;
            cy = (y + 1) * gridSize - offset / 2;
            bottom(x, y);
            left(x, y);
            break;
        default:
            cx = 0;
            cy = 0;
            break;
        }
        
        for (int i = 0; i < tSeg; i++) {
            walls.add(new Boundary(cx + rSmall * sin(radians(i * deg - angleOff)), cy + rSmall * cos(radians(i * deg - angleOff)),
                                   cx + rSmall * sin(radians((i + 1) * deg - angleOff)), cy + rSmall * cos(radians((i + 1) * deg - angleOff))));
            walls.add(new Boundary(cx + rBig * sin(radians(i * deg - angleOff)), cy + rBig * cos(radians(i * deg - angleOff)),
                                   cx + rBig * sin(radians((i + 1) * deg - angleOff)), cy + rBig * cos(radians((i + 1) * deg - angleOff))));                                     
        }
    }
    
    void top(int x, int y) {
        int xPos = x * gridSize;
        int yPos = y * gridSize;
        walls.add(new Boundary(xPos + offset           , yPos, xPos + offset           , yPos + offset / 2));
        walls.add(new Boundary(xPos + gridSize - offset, yPos, xPos + gridSize - offset, yPos + offset / 2));
    }
    
    void right(int x, int y) {
        int xPos = (x + 1) * gridSize;
        int yPos = y * gridSize;
        walls.add(new Boundary(xPos, yPos + offset           , xPos - offset / 2, yPos + offset           ));
        walls.add(new Boundary(xPos, yPos + gridSize - offset, xPos - offset / 2, yPos + gridSize - offset));
    }
    
    void bottom(int x, int y) {
        int xPos = x * gridSize;
        int yPos = (y + 1) * gridSize;
        walls.add(new Boundary(xPos + offset           , yPos, xPos + offset           , yPos - offset / 2));
        walls.add(new Boundary(xPos + gridSize - offset, yPos, xPos + gridSize - offset, yPos - offset / 2));
    }
    
    void left(int x, int y) {
        int xPos = x * gridSize;
        int yPos = y * gridSize;
        walls.add(new Boundary(xPos, yPos + offset           , xPos + offset / 2, yPos + offset           ));
        walls.add(new Boundary(xPos, yPos + gridSize - offset, xPos + offset / 2, yPos + gridSize - offset));
    }
    
    Square getSquare(int x, int y) {
        for (Square s : squares) {
            if (s.x == x && s.y == y) {
                return s;   
            }
        }
        return null;
    }
}
