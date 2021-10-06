class Car {
    float r;

    PVector pos;
    float rot;
    float heading;
    float vel;
    float acc;
    float speedTot;

    float minSpeed;
    float maxSpeed;
    int maxLife;
    int timer;
    int lifeCount;
    
    float prevScore;
    float score;
    float laps;
    
    NN network;
    
    int timeAlive;
    
    boolean crashed;

    float[] distances;
    Ray[] rays;

    Car() {
        this(new NN(13, 4));    
    }
    
    Car(NN network) {
        minSpeed = 0;
        maxSpeed = 6;
        maxLife = 1500;
        r = 4;
        pos = new PVector(75, 749);
        rot = 0;
        heading = radians(270);
        vel = minSpeed;
        acc = 0;
        timer = 40;
        lifeCount = 40;        
        prevScore = 0;
        score = 1;
        laps = 0;
        crashed = false;
        
        this.network = network;
        
        distances = new float[11];
        rays = new Ray[11];
        
        for (int i = -5; i <= 5; i++) {
            rays[i + 5] = new Ray(pos, heading + radians(i * 18));
        }  
    }

    void update() {
        if (!crashed) {
            timeAlive++;
            
            if (vel < 0.5) {
                lifeCount--;   
            } else {
                lifeCount = timer;      
            }
            
            if (lifeCount < 1) {
                crashed = true;   
            }
            
            vel += acc;
            if (vel > maxSpeed) {
                vel = maxSpeed;   
            }
            
            pos.x += vel * cos(heading);
            pos.y += vel * sin(heading);
            
            vel -= 0.05;
            if (vel < minSpeed) {
                vel = minSpeed;   
            }
            
            speedTot += vel;
    
            for (int i = -5; i <= 5; i++) {
                rays[i + 5] = new Ray(pos, heading + radians(i * 18));
            }
        } 
    }
    
    void setAcc(float a) {
        acc = a;   
    }
    
    void setRotation(float r) {
        rot = r;   
    }
    
    void think() {
        float[] inputs = new float[13];
        inputs[0] = vel;
        inputs[1] = heading;
        for (int i = 0; i < 11; i++) {
            inputs[i + 2] = distances[i];   
        }
        
        float[] output = network.feedforward(inputs);
        
        if (output[0] == 1.0) {
            setAcc(0.2);   
        }
        
        if (output[1] == 1.0) {
            setAcc(-0.15);       
        } 
        
        if (output[0] == 0.0 && output[1] == 0.0) {
            setAcc(0.0);   
        }
        
        if (output[2] == 1.0) {
            setRotation(0.07);   
        } 
        
        if (output[3] == 1.0) {
            setRotation(-0.07);
        } 
        
        if (output[2] == 0.0 && output[3] == 0.0) {
            setRotation(0);   
        }
        
    }
    
    void turn() {
        if (this.vel > 1) {
            heading += 3 * rot / this.vel;    
        } else {
            heading += rot;   
        }
    }

    void look(ArrayList<Boundary> walls) {
        float d = 0;
        for (int i = 0; i < this.rays.length; i++) {
            Ray ray = this.rays[i];
            PVector closest = null;
            float record = 100000;
            for (Boundary wall : walls) {
                PVector pt = ray.cast(wall);
                if (pt != null) {
                    d = PVector.dist(this.pos, pt);
                    if (d < record) {
                        record = d;
                        closest = pt;
                    }
                }
            }

            if (closest != null) {
                d = PVector.dist(this.pos, closest);
                distances[i] = d;
                //color blue = color(0, 100, 255);
                //color red = color(255, 0, 0);
                //color col = lerpColor(red, blue, 90 / d);
                //stroke(col);
                //strokeWeight(1);
                //line(this.pos.x, this.pos.y, closest.x, closest.y);
            }
        }
    }
    
    void crash() {
        for (Float f : distances) {
            if (f < maxSpeed + 1 && timeAlive > 5) {
                crashed = true; 
                score--;
            }
        }
        
        if (timeAlive > maxLife) {
            crashed = true;   
            score--;
        }
        
        if (lifeCount == 0) {
            crashed = true;   
            score--;
        }
    }
    
    void getScore(Track track) {
        prevScore = score;
        int[] gPos = getGridPos(track);
        Square s = track.getSquare(gPos[0], gPos[1]);
        if (s == null) {
            return;   
        }
        Checkpoint closest = null;
        float record = 10000;
        float d = 0;
        for (Checkpoint c : s.points) {
            d = PVector.dist(pos, c.pos);
            if (d < record) {
                record = d;
                closest = c;
            }
        }
        if (closest != null) {
            if (closest.score >= prevScore) {
                if (closest.score == 29.0 && prevScore < 28) {
                    crashed = true;
                    return;
                }
                score = closest.score;      
                if (score == 29.0) {
                    crashed = true;   
                }
            }
        }
    }
    
    int[] getGridPos(Track track) {
        int[] gPos = new int[2];
        gPos[0] = (int) pos.x / track.gridSize;
        gPos[1] = (int) pos.y / track.gridSize;
        return gPos;
    }

    void display() {
        float angle = heading + PI / 2;
        
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(angle);
        
        if (crashed) {
            fill(255, 0, 0);    
        } else {
            color slow = color(0, 100, 255);
            color fast = color(0, 255, 100);
            color fill = lerpColor(slow, fast, (vel - minSpeed) / (maxSpeed - minSpeed));
            fill(fill);   
        }
        noStroke();
        beginShape();
        vertex(0, -r * 2);
        vertex(-r, r * 2);
        vertex(r, r * 2);
        endShape(CLOSE);

        popMatrix();
    }

    void boundaries() {
        if (pos.x < 0) {
            pos.x = height;
        } else if (pos.x > height) {
            pos.x = 0;
        }

        if (pos.y < 0) {
            pos.y = height;
        } else if (pos.y > height) {
            pos.y = 0;
        }
    }
}
