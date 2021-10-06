class Square {
    
    int size;
    int x;
    int y;
    boolean turn;
    int rotation;
    int score;
    boolean right;
    Checkpoint[] points = new Checkpoint[6];
    
    
    Square(int size, int x, int y, int rotation, int score, boolean... args) {
        this.size = size;
        this.x = x;
        this.y = y;
        this.turn = args[0];
        this.rotation = rotation;
        this.score = score;
        if (args.length > 1) {
            this.right = args[1];
        }
        
        int xPos = this.x * this.size;
        int yPos = this.y * this.size;
        int half = this.size / 2;
        PVector[] directions = new PVector[4];
        directions[0] = new PVector(xPos + half, yPos);
        directions[1] = new PVector(xPos + this.size, yPos + half);
        directions[2] = new PVector(xPos + half, yPos + this.size);
        directions[3] = new PVector(xPos, yPos + half);
        
        if (!this.turn) {
            points[0] = new Checkpoint(directions[(this.rotation + 2) % 4], this.score);
            points[5] = new Checkpoint(directions[this.rotation], this.score + 1);
            
            for (int i = 1; i <= 4; i++) {
                points[i] = new Checkpoint(PVector.lerp(points[0].pos, points[5].pos, i * 0.2), this.score + i * 0.2);   
            }
            
        } else {
            if (this.right) {
                points[0] = new Checkpoint(directions[this.rotation], this.score);
                points[5] = new Checkpoint(directions[(this.rotation + 3) % 4], this.score + 1);
                generateTurnPoints(points, this.rotation);
            } else {
                points[0] = new Checkpoint(directions[(this.rotation + 3) % 4], this.score);
                points[5] = new Checkpoint(directions[this.rotation], this.score + 1);
                generateTurnPoints(points, this.rotation);
            }
        }
    }
    
    void showPoints() {
        noStroke();
        color start = color(255, 0, 0);
        color end = color(0, 100, 255);
        fill(start);
        ellipse(points[0].pos.x, points[0].pos.y, 10, 10);
        
        for (int i = 1; i <= 4; i++) {
            fill(lerpColor(start, end, i * 0.2));
            ellipse(points[i].pos.x, points[i].pos.y, 10, 10);
        }
        
        fill(end);
        ellipse(points[5].pos.x, points[5].pos.y, 10, 10);
    }
    
    void generateTurnPoints(Checkpoint[] points, int rotation) {
        int cx;
        int cy;
        if (rotation == 0) {
            cx = x * size;
            cy = y * size;
        } else if (rotation == 1) {
            cx = (x + 1) * size;
            cy = y * size;
        } else if (rotation == 2) {
            cx = (x + 1) * size;
            cy = (y + 1) * size;
        } else {
            cx = x * size;
            cy = (y + 1) * size;
        }
        
        int radius = size / 2;
        int deg = rotation * 90;
        if (this.right) {
            for (int i = 1; i <= 4; i++) {
                points[i] = new Checkpoint(new PVector(cx + radius * cos(radians(deg + i * 18)), 
                                                       cy + radius * sin(radians(deg + i * 18))),
                                                       score + (0.2 * i));
            }
        } else {
            for (int i = 1; i <= 4; i++) {
                points[i] = new Checkpoint(new PVector(cx + radius * cos(radians(deg + 90 - (i * 18))), 
                                                       cy + radius * sin(radians(deg + 90 - (i * 18)))),
                                                       score + (0.2 * i));
            }
        }
    }
    
    void highlight() {
        noStroke();
        fill(255, 50);   
        rect(x * size, y * size, size, size);
    }
}
