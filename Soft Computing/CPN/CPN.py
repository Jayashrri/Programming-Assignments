import numpy as np
import random

class CPN:
    def __init__(self, l_x, l_y, l_z, dataset):
        self.x_weights = np.random.randn(l_z, l_x) 
        self.y_weights = np.random.randn(l_z, l_y)
        self.xz_weights = np.random.randn(l_z, l_x)
        self.yz_weights = np.random.randn(l_z, l_y)
        self.x_learning = random.randint(1, 10)
        self.y_learning = random.randint(1, 10)
        self.xz_learning = random.randint(1, 10)
        self.yz_learning = random.randint(1, 10)
        self.x_stopping = 0.05
        self.y_stopping = 0.05
        
        self.l_x = l_x
        self.l_y = l_y
        self.l_z = l_z
        self.dataset = dataset
        
    def forward(self):
        for data in self.dataset:
    	     x = data[:self.l_x]
    	     y = data[self.l_x:]
    	     D = np.empty((1, self.l_z))
    	     
    	     for i in range(self.l_z):
    	         D[i] = np.sum(np.square(x-self.x_weights[i])) + np.sum(np.square(y-self.y_weights[i]))
    	     winning = np.argmin(D)
    	     
    	     self.x_weights[winning] = self.x_weights[winning] + self.x_learning*(x-self.x_weights[winning])
    	     self.y_weights[winning] = self.y_weights[winning] + self.y_learning*(y-self.y_weights[winning])
    	 
        self.x_learning = self.x_learning*0.5
        self.y_learning = self.y_learning*0.5
    	 
        if self.x_learning < self.x_stopping or self.y_learning < self.y_stopping:
    	     return True
        else:
    	     return False

    def backward(self):
        for data in self.dataset:
    	     x = data[:self.l_x]
    	     y = data[self.l_x:]
    	     D = np.empty((1, self.l_z))
    	     
    	     for i in range(self.l_z):
    	         D[i] = np.sum(np.square(x-self.x_weights[i])) + np.sum(np.square(y-self.y_weights[i]))
    	     winning = np.argmin(D)
    	     
    	     self.x_weights[winning] = self.x_weights[winning] + self.x_learning*(x-self.x_weights[winning])
    	     self.y_weights[winning] = self.y_weights[winning] + self.y_learning*(y-self.y_weights[winning])
    	     
    	     self.xz_weights[winning] = self.xz_weights[winning] + self.xz_learning*(x-self.xz_weights[winning])
    	     self.yz_weights[winning] = self.yz_weights[winning] + self.yz_learning*(y-self.yz_weights[winning])
    	 
        self.xz_learning = self.xz_learning*0.5
        self.yz_learning = self.yz_learning*0.5
    	 
        if self.xz_learning < self.x_stopping or self.yz_learning < self.y_stopping:
    	     return True
        else:
    	     return False
    	     
    def train(self):
        completed = False
        while not completed:
            completed = self.forward()
        
        completed = False
        while not completed:
            completed = self.backward()
        
    def display(self):
        print("X Weights: \n")
        print(self.x_weights)
        print("\n")
        
        print("Y Weights: \n")
        print(self.y_weights)
        print("\n")
        
        print("X* Weights: \n")
        print(self.xz_weights)
        print("\n")
        
        print("Y* Weights: \n")
        print(self.yz_weights)
        print("\n")
            

def main():
    random.seed(10)
    data = [[7.26500383447598, 2.0653591885201537, 0], [0.5525484448579303, -6.224152558120171, 1], [8.216168749032597, 0.4160091158214676, 0], [7.39845746501804, 2.5924670433839605, 0], [1.9515867916421965, -4.332217895679391, 1], [2.290569909263561, -7.707979807897941, 1], [1.004383290883327, -5.9650408817419605, 1], [7.644188193280051, 0.439559580416354, 0], [6.156310477113076, -0.5521688579439736, 0], [2.860688039342736, -7.043458166088344, 1], [0.19872261597252194, -4.6652428392516345, 1], [6.179005371372015, 0.7384959776935596, 0], [2.3092256318460027, -6.352585958502032, 1], [6.791810340925112, 0.1601181178815227, 0], [6.078832501116052, 1.015853872671454, 0], [5.956625497423398, -0.7438328281945819, 0], [1.393435591476471, -6.794046243061609, 1], [6.063435329937389, 1.2895385074869048, 0], [5.461012032551585, 0.3578337562693804, 0], [0.07111482284723292, -6.0544741193740785, 1], [-0.8166142507415453, -4.759582902530127, 1], [0.9935960321535714, -6.2292869397278645, 1], [0.4268007713140083, -5.543079516144951, 1], [1.9560086330245121, -5.867072303627447, 1], [8.725706623650924, 1.363008458680656, 0], [1.6727614943299944, -6.025071433442461, 1], [4.977698583351427, 0.3110567594758824, 0], [8.97133632813014, 1.1071572465753858, 0], [6.810211247960693, 1.5900732625447098, 0], [-1.9403368381798956, -5.063667352675927, 1], [2.1329944562017618, -6.286586384726649, 1], [6.8441758682008835, 1.6754129999892196, 0], [1.845174516601686, -6.817217787959532, 1], [0.35958160169683784, -5.374403218232643, 1], [1.5100163066683823, -4.286059862967011, 1], [1.948993578532614, -5.904932106938887, 1], [1.3384015323096394, -5.695511340334829, 1], [7.224907937635306, 2.296476144616795, 0], [8.159941304761052, -0.394450020311627, 0], [5.409698998228733, 0.2732393150274893, 0], [7.152891633337372, 0.3120027241734238, 0], [6.601019427985308, -0.30629037938235615, 0], [6.73938440746622, 1.374987327625715, 0], [-0.26499159563817676, -5.13245424561941, 1], [5.35743322706022, 1.3053284332169723, 0], [6.779952675376557, 0.8411842802736065, 0], [-0.3841581589317118, -5.8848116420683665, 1], [0.16091124015518043, -5.617833261672856, 1], [0.2961121018054921, -6.638712278849767, 1], [6.345053826228942, 0.19479291998878434, 0]]
    
    dataset = np.asarray(data, dtype=np.float32)
    print(dataset)
    
    network = CPN(2, 2, 1, dataset)
    print("Initial Weights:")
    network.display()
    
    network.train()
    print("Final Weights:")
    network.display()
   
if __name__ == '__main__':
    main()
