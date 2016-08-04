function [ trainTestRatio, NRMSE, cond_A, cond_B ] = ...
    AnalyzeData( outputData_Y, exogeneous_U, percentTrain, showFigures)
%AnalyzeData returns analysis results on given Y & U data
%   ...

% disp('uuuu');
% disp(exogeneous_U);

% split the data
[trainData, testData, trainTestRatio] = randomSelectionSplit(outputData_Y, exogeneous_U, percentTrain);

if showFigures == true
    plot(trainData);
    title('Training Data');
    figure;
    plot(testData);
    title('Validation Data');
end
    
% train the arx model
[ sys, Y, X, cond_A, cond_B ] = behavARX( trainData, 2);

[~,NRMSE,~] = compare(iddata(outputData_Y, exogeneous_U), sys);
disp(NRMSE);
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
