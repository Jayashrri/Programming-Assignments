data = readtable('pima-indians-diabetes.csv', "VariableNamingRule", "preserve");
labelName = 'outcome';
data = convertvars(data,labelName,'categorical');
cv = cvpartition(size(data, 1), 'HoldOut', 0.3);
idx = cv.test;
dataTrain = data(~idx,:);
dataTest  = data(idx,:);
[trainSizeM, trainSizeN] = size(dataTrain);
[testSizeM, testSizeN] = size(dataTest);
xTrain = dataTrain(:, 1:trainSizeN - 1);
yTest.outcome = categorical(dataTest(:, testSizeN).outcome);
inputSize = size(xTrain);

layers = [
    featureInputLayer(inputSize(2), 'Normalization', 'zscore')
    fullyConnectedLayer(6)
    reluLayer
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer
];

batchSize = 32;
options = trainingOptions('adam', 'MiniBatchSize',batchSize, ... 
    'Shuffle','every-epoch', ...
    'MaxEpochs', 30, ...
    'ValidationData', dataTest, ...
    'ValidationFrequency',30, ...
    'Plots','training-progress', ...
    'Verbose',false);

net = trainNetwork(dataTrain, layers, options);

yPred = classify(net, dataTest, 'MiniBatchSize', batchSize);
accuracy = sum(yPred == yTest.outcome)/numel(yTest.outcome);
fprintf("accuracy: ");
disp(accuracy);