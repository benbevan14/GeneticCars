class NN {
    
    int in;
    int out;
    float[][] weights;
    float[] bias;
      
    NN(int in, int out) {
        this.in = in;
        this.out = out;
        weights = new float[in][out];
        bias = new float[out];
        
        for (int i = 0; i < in; i++) {
            for (int j = 0; j < out; j++) {
                weights[i][j] = random(-0.1, 0.1);
            }
        }
        for (int i = 0; i < out; i++) {
            bias[i] = random(-0.1, 0.1);
        }
    }
    
    NN(float[][] weights, float[] bias) {
        this.in = weights.length;
        this.out = weights[0].length;
        this.weights = weights;
        this.bias = bias;
    }
    
    float[] feedforward(float[] inputs) {
        float[] output = new float[out];
        float[] sums = {0, 0, 0, 0};
        for (int i = 0; i < in; i++) {
            for (int j = 0; j < out; j++) {
                sums[j] += inputs[i] * weights[i][j]; 
            }
        }
        for (int i = 0; i < out; i++) {
            sums[i] += bias[i];   
            output[i] = round(activate(sums[i]));
        }
        
        return output;
    }
    
    float activate(float input) {
        float num = exp(input);
        float den = exp(input) + 1;
        return num / den;
    }
    
    //void show() {
    //    for (Float f : w1) {
    //        System.out.print(round(f * 1000.0) / 1000.0 + "  ");
    //    }
    //    System.out.println();
    //    for (Float f : w2) {
    //        System.out.print(round(f * 1000.0) / 1000.0 + "  ");
    //    }
    //    System.out.println();
    //    for (Float f : w3) {
    //        System.out.print(round(f * 1000.0) / 1000.0 + "  ");   
    //    }
    //    System.out.println();
    //    for (Float f : bias) {
    //        System.out.print(round(f * 1000.0) / 1000.0 + "  ");   
    //    }
    //    System.out.println("\n");
    //}
}
