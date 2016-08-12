function [ trainTestRatio, NRMSE, conditionNum] = ...
    AnalyzeData( outputData_Y, exogeneous_U, amountTrain, amountTest, ...
        split_type, modelOrder, showFigures)
%AnalyzeData returns analysis results on given Y & U data
%   ...

% TODO: how to get n_train_chunks, n_test_chunks OR percentTrain ???
% function overloading???

% disp('uuuu');
% disp(exogeneous_U);

% split the data
if split_type == splitType.randomPoints
%     disp('split pts');
    [trainData, testData, trainTestRatio] = randomSelectionSplit(...
        outputData_Y, exogeneous_U, amountTrain/(amountTest+amountTrain));
elseif split_type == splitType.randomChunks
%     disp('split chunks');
    [trainData, testData, trainTestRatio] = chunkSplit(outputData_Y, ...
        exogeneous_U, amountTrain, amountTest);
else
    disp('ERR: given splitType ' + split_type + ' not recognized.');
end        

if showFigures == true
    plot(trainData);
    title('Training Data');
    figure;
    plot(testData);
    title('Validation Data');
end
    
% train the arx model
[ sys, theta, conditionNum ] = behavARX( trainData, modelOrder, false);
% sys

[~,NRMSE,~] = compare(iddata(outputData_Y, exogeneous_U), sys);
% disp(NRMSE);
if showFigures == true
    figure;
    compare(iddata(outputData_Y, exogeneous_U), sys);
    title('Model vs Data');
end
    
if exist('mockSys', 'var')
    Adiff = mockSys.a - sys.a;
    Bdiff = mockSys.b - sys.b;
    if showFigures == true
        disp('actual vs learned coeffs:');
        disp('A-A`=')
        disp(Adiff)
        disp('B-B`=')
        disp(Bdiff)
    end
end

% if showFigures == true
%     disp('GoF metrics:');
% end
% prediction = sim(sys, exogeneous_U);
% ssd = sum( (outputData_Y(:) - prediction(:)).^2 );
% 
% if showFigures == true
%     fprintf('test fit SSD: %d\n', ssd);
% end
% 
% [R,P] = corrcoef(outputData_Y, prediction);
% if showFigures == true
%     fprintf('R=%d\n', R(2));
%     figure;
%     showConfidence(bodeplot(sys))
% end

end
