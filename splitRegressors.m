function [ train, test, trainY, testY, trainVals, testVals ] ...
    = splitRegressors( regressors, data )
%splitRegressors divides given regressor matrix into train/test
%   returns lists of indicies

train = [];
trainVals = [];
trainY = [];
test = [];
testVals = [];
testY = [];
for t = 1:length(data)
    if rand < .8
        train(length(train)+1) = t;
        trainVals(:, length(trainVals)+1) = regressors(:, t);
        trainY(length(trainY)+1) = data(t);
    else 
        test(length(test)+1) = t;
        testVals(:, length(testVals)+1) = regressors(:, t);
        testY(length(testY)+1) = data(t);
    end
end

fprintf('train:test = %d/%d (%d%% train)\n', ...
    length(train), length(test), ... 
    round(100*length(train)/(length(train)+length(test))));

end

