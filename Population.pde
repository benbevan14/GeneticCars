class Population {
    
    int size;
    ArrayList<Car> cars;
    boolean dead;
    
    Population(int size) {
        this.size = size;
        this.cars = new ArrayList<Car>();
        this.dead = false;
        
        for (int i = 0; i < size; i++) {
            cars.add(new Car());   
        }
    }
    
    void generateNew() {
        ArrayList<Car> weighted = new ArrayList<Car>();
        
        for (Car c : cars) {
            int times = (int) c.score * 10 * (int) (c.speedTot / c.timeAlive);
            if (c.equals(bestTime())) {
                times *= 3;
            }
            
            for (int i = 0; i < times; i++) {
                weighted.add(c);   
            }
        }
        
        ArrayList<Car> newCars = new ArrayList<Car>();
        ArrayList<Car> genePool = new ArrayList<Car>();
        
        for (int i = 0; i < size * 2; i++) {
            genePool.add(select(weighted));   
        }
        
        for (int i = 0; i < size * 2; i += 2) {
            newCars.add(crossover(genePool.get(i), genePool.get(i + 1)));
        }
        
        for (int i = 0; i < size; i++) {
            mutate(newCars.get(i));   
        }
        
        cars = newCars;
    }
    
    Car select(ArrayList<Car> list) {
        int r1 = int(random(0, list.size()));
        int r2 = int(random(0, list.size()));
        while (r2 == r1) {
            r2 = int(random(0, list.size()));   
        }
        
        Car a = list.get(r1);
        Car b = list.get(r2);
        
        if (a.score > b.score) {
            return a;   
        } else if (a.score < b.score) {
            return b;   
        } else {
            return a;   
        }
    }
    
    Car crossover(Car a, Car b) {
        float[][] weights = new float[a.network.in][a.network.out];
        float[] bias = new float[a.network.out];
        
        float[][] aN = a.network.weights;
        float[][] bN = b.network.weights;
        float[] aBias = a.network.bias;
        float[] bBias = b.network.bias;
        
        for (int i = 0; i < a.network.in; i++) {
            for (int j = 0; j < a.network.out; j++) {
                if (int(random(0, 2)) == 1) {
                    weights[i][j] = aN[i][j];   
                } else {
                    weights[i][j] = bN[i][j];   
                }
            }
        }
        
        for (int i = 0; i < a.network.out; i++) {
            if (int(random(0, 2)) == 1) {
                bias[i] = aBias[i];   
            } else {
                bias[i] = bBias[i];   
            }
        }
        
        NN net = new NN(weights, bias);
        return new Car(net);
    }
    
    void mutate(Car c) {
        for (int i = 0; i < c.network.in; i++) {
            for (int j = 0; j < c.network.out; j++) {
                if (int(random(0, 30)) == 0) {
                    c.network.weights[i][j] += random(-0.1, 0.1);   
                }
            }
        }
        
        for (int i = 0; i < c.network.out; i++) {
            if (int(random(0, 30)) == 0) {
                c.network.bias[i] += random(-0.1, 0.1);   
            }
        }
    }
    
    boolean checkDead() {
        for (Car c : cars) {
            if (!c.crashed) {
                return false;      
            }
        }
        return true;
    }
    
    Car highScore() {
        float record = 0;
        Car winner = null;
        for (Car c : cars) {
            if (c.score > record) {
                record = c.score;
                winner = c;
            }
        }
        return winner;
    }
    
    float avgScore() {
        float sum = 0;
        for (Car c : cars) {
            sum += c.score;   
        }
        
        return round((sum / size) * 100.0) / 100.0;
    }
    
    Car bestTime() {
        Car winner = null;
        int record = 10000;
        for (Car c : cars) {
            if (c.score == 29.0 && c.timeAlive < record) {
                winner = c;
                record = c.timeAlive;   
            }
        }
        if (winner != null) {
            return winner;      
        }
        return highScore();
    }
    
    int carsAlive() {
        int counter = 0;
        for (Car c : cars) {
            if (!c.crashed) {
                counter++;   
            }
        }
        return counter;
    }
    
    void show() {
        for (Car c : cars) {
            System.out.println(c.score);
            //c.network.show();   
        }
    }
}
