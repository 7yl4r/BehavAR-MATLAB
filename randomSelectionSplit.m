function [ trainData, testData, ratio ] = randomSelectionSplit( ...
    outputData_Y, exogeneous_U, percentTrain, verbose)
% given two data arrays, returns test and training set data objects.
% points are randomly assigned to either test/training.

if ~exist('verbose', 'var')
    verbose = false;
end

if verbose
    fprintf('splitting out apprx %d p train\n', percentTrain);
end

t = 1;
% disp('u');
% disp(exogeneous_U);
% disp('t');
% disp(exogeneous_U(t));
% disp('-');
% disp(exogeneous_U(t,:));
% disp('-');
% disp(exogeneous_U(:,t));

n_test = 0;
n_train = 0;
trainU = zeros(size(exogeneous_U));
trainY = [length(outputData_Y)];
testU = zeros(size(exogeneous_U));
testY = [length(outputData_Y)];
% disp(size(trainU));
% disp(size(exogeneous_U));
for t = 1:length(outputData_Y)
    if rand < percentTrain
        trainU(t,:) = exogeneous_U(t,:);
        trainY(t) = outputData_Y(t);
        testU(t,:) = nan;
        testY(t) = nan;
        n_train = n_train+1;
    else 
        trainU(t,:) = nan;
        trainY(t) = nan;
        testU(t,:) = exogeneous_U(t,:);
        testY(t) = outputData_Y(t);
        n_test = n_test+1;
    end
end

ratio = round(100*n_train/(n_train+n_test));

if verbose
    fprintf('train:test = %d/%d (%d%% train)\n', ...
        n_train, n_test, ratio);
%     disp(size(trainY'))
%     disp(size(trainU));
end

trainData = iddata(trainY', trainU);
testData  = iddata(testY',  testU);

end

