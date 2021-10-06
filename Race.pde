Population pop;
Track track;
ArrayList<Boundary> walls = new ArrayList<Boundary>();
int generation;
ArrayList<Float> highScores = new ArrayList<Float>();
ArrayList<Float> avgScores = new ArrayList<Float>();
ArrayList<PVector> highScorePoints = new ArrayList<PVector>();
ArrayList<PVector> avgScorePoints = new ArrayList<PVector>();

PFont font;

void setup() {
    size(1800, 900);
    track = new Track();
    pop = new Population(200);
    generation = 1;
    
    font = createFont("Comic Sans MS", 20);
    textFont(font);

    walls.add(new Boundary(0, 0, height, 0));
    walls.add(new Boundary(height, 0, height, height));
    walls.add(new Boundary(height, height, 0, height));
    walls.add(new Boundary(0, height, 0, 0));
    for (Boundary b : track.walls) {
        walls.add(b);
    }
}

void draw() {
    background(51);
    
    fill(51);
    rect(900, 0, 900, 900);
    
    stroke(255);
    strokeWeight(2);
    
    PVector origin = new PVector((width / 2) * 1.125, height * 0.875);
    PVector xAxis  = new PVector((width / 2) * 1.875, height * 0.875);
    PVector yAxis  = new PVector((width / 2) * 1.125, height * 0.125);
    
    float numX = (highScores.size() + 1 > 10 ? highScores.size() + 1 : 10.0);
    float numY = 30.0;
    float xScale = (3 * height / 4) / numX;
    float yScale = (3 * height / 4) / numY;
    
    if (pop.checkDead()) {
        System.out.println("Generation: " + generation);
        System.out.println("High score: " + pop.highScore().score);
        highScores.add(pop.highScore().score);
        System.out.println("Average score: " + pop.avgScore());
        avgScores.add(pop.avgScore());
        System.out.println("Best time: " + pop.bestTime().timeAlive + "\n");
        
        highScorePoints.clear();
        avgScorePoints.clear();
        for (int i = 1; i <= highScores.size(); i++) {
            float x = origin.x + i * xScale;
            float highY = origin.y - highScores.get(i - 1) * yScale;
            float avgY  = origin.y - avgScores.get(i - 1) * yScale;
            
            highScorePoints.add(new PVector(x, highY));
            avgScorePoints.add(new PVector(x, avgY));
        }

        pop.generateNew();
        generation++;
    }

    numX = (highScores.size() > 10 ? highScores.size() : 10.0);
    numY = 30.0;
    xScale = (3 * height / 4) / numX;
    yScale = (3 * height / 4) / numY;
        
    textSize(20);
    fill(255);
    
    push();
    PVector pos = PVector.lerp(origin, yAxis, 0.5);
    translate(pos.x, pos.y);
    rotate(-PI / 2);
    text("Score", -10, -40);
    pop();
    
    pos = PVector.lerp(origin, xAxis, 0.5);
    text("Generation", pos.x - 50, pos.y + 50);
    
    line(origin.x, origin.y, xAxis.x, xAxis.y);
    line(origin.x, origin.y, yAxis.x, yAxis.y);
    
    textSize(12);
    
    // draw the ticks and values on the x axis
    for (int x = 0; x <= (int) numX; x++) {
        if ((int) x % 2 == 0) {
            PVector start = PVector.lerp(origin, xAxis, x / numX);
            line(start.x, start.y, start.x, start.y + 5);
            float w = textWidth(x + "");
            text(x + "", start.x - (w / 2), start.y + 20);
        }
    }
    
    // draw the ticks and values on the y axis
    for (int y = 0; y <= (int) numY; y++) {
        PVector start = PVector.lerp(origin, yAxis, y / numY);
        line(start.x, start.y, start.x - 5, start.y);
        float h = textWidth(y + "");
        text(y + "", start.x - h - 10, start.y + 5);
    }
    
    for (PVector p : highScorePoints) {
        fill(255, 165, 0);
        noStroke();
        ellipse(p.x, p.y, 5, 5);
    }
    
    for (PVector p : avgScorePoints) {
        fill(0, 200, 255);
        noStroke();
        ellipse(p.x, p.y, 5, 5);
    }
    
    for (int i = 0; i < highScorePoints.size() - 1; i++) {
        PVector p = highScorePoints.get(i);
        PVector p1 = highScorePoints.get(i + 1);
        stroke(255, 165, 0);
        line(p.x, p.y, p1.x, p1.y); 
    }
    
    for (int i = 0; i < avgScorePoints.size() - 1; i++) {
        PVector p = avgScorePoints.get(i);
        PVector p1 = avgScorePoints.get(i + 1);
        stroke(0, 200, 255);
        line(p.x, p.y, p1.x, p1.y); 
    }

    for (Boundary wall : walls) {
        wall.show();
    }
    
    fill(255);
    textSize(25);
    text("Cars alive: " + pop.carsAlive(), 10, 25);

    for (Car c : pop.cars) {
        //Car c = cars.get(i);
        
        if (!c.crashed) {
            //c.seek(new PVector(width / 2, height / 2));
            c.look(walls);
            c.crash();
            c.boundaries();
            c.think();
            c.turn();
            c.update();        
            c.getScore(track);
        } 
        c.display();
    }
}

//void keyReleased() {
//    Car c = cars.get(0);

//    if (keyCode == UP) {
//        c.setAcc(0);
//    }

//    if (keyCode == RIGHT || keyCode == LEFT) {
//        c.setRotation(0);
//    }
//}

//void keyPressed() {
//    Car c = cars.get(0);
//    if (!c.crashed) {
//        if (keyCode == UP) {
//            c.setAcc(0.2);
//        }
    
//        if (keyCode == RIGHT) {
//            c.setRotation(0.07);
//        } else if (keyCode == LEFT) {
//            c.setRotation(-0.07);
//        }
//    }
//}
