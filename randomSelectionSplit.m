function [ trainData, testData, ratio ] = randomSelectionSplit( outputData_Y, exogeneous_U )
% given two data arrays, returns test and training set data objects.
% points are randomly assigned to either test/training.

n_test = 0;
n_train = 0;
trainU = [length(outputData_Y)];
trainY = [length(outputData_Y)];
testU = [length(outputData_Y)];
testY = [length(outputData_Y)];
for t = 1:length(outputData_Y)
    if rand < .8
        trainU(t) = exogeneous_U(t);
        trainY(t) = outputData_Y(t);
        testU(t) = nan;
        testY(t) = nan;
        n_train = n_train+1;
    else 
        trainU(t) = nan;
        trainY(t) = nan;
        testU(t) = exogeneous_U(t);
        testY(t) = outputData_Y(t);
        n_test = n_test+1;
    end
end

ratio = round(100*n_train/(n_train+n_test));

%  fprintf('train:test = %d/%d (%d%% train)\n', ...
%      n_train, n_test, ratio);

trainData = iddata(trainY', trainU');
testData  = iddata(testY',  testU' );

end

