from sklearn.datasets import make_blobs
import numpy as np

X, y = make_blobs(n_samples=50, centers=2, n_features=2)
Z = np.empty((50,3))
for i in range(50):
	Z[i] = np.append(X[i],y[i])

Z = Z.tolist()
for i in range(50):
	Z[i][2] = int(Z[i][2])

print(Z)
