% fake data:
exogeneous_U = mockInputData(1000, 'random');  
mockSys = idpoly([1, .5, -.5], [0, .1, 1]);  % mock arx model
outputData_Y = sim(mockSys, exogeneous_U);

% split the data
[trainData, testData] = randomSelectionSplit(outputData_Y, exogeneous_U);

plot(trainData);
figure;
plot(testData);

% train the arx model
[ sys, Y, X ] = behavARX( trainData, 2 );

figure;
compare(iddata(outputData_Y, exogeneous_U), sys);


% plotTrainTest( outputData_Y, train, trainY, test, testY );

% %plotRegressorSlopes(train, trainY, trainVals, outputData_Y, lags);
% plotRegressorSlopes(train, trainY, regressors, outputData_Y, lags);
% plotRegressorPointConnect(train, trainY, outputData_Y, lags);


% % use train regressors to do autoregression
% sums = zeros(1, length(lags));  % sum of train regressors
% avgs = zeros(1, length(lags));
% for i = 1:length(train)
%     t = train(i);  % time index of selected train item
%     for tao = 1:length(lags)
%         sums(tao) = regressors(tao, t) + sums(tao);
%     end
% end
% 
% for tao = 1:length(lags)
%     avgs(tao) = sums(tao)/length(train);
% end
% fprintf('\t=== avg regressors ===\n');
% fprintf('lags: ');
% fprintf('\t%8.0f', lags);
% fprintf('\n');
% fprintf('rhos: ');
% fprintf('\t%3.2d', avgs);
% fprintf('\n');
% 
% % compute predictions from all data
% data_predict = zeros(length(outputData_Y));
% for t = 1:length(outputData_Y)
%     data_predict(t) = 0;
%     for tao = 1:length(lags)
%         if t-tao > 0
%             data_predict(t) = data_predict(t) ...
%                 + avgs(tao)*outputData_Y(t-tao);
%         end
%     end
% end
% 
% % evaluate data on test set
% actual = zeros(length(test));
% predict= zeros(length(test));
% for i = 1:length(test)
%     t = test(i);  % time index of selected train item
%     actual(i) = outputData_Y(t);
%     predict(i)= data_predict(t);
% end
% 
% %ssd = sum( (actual(:) - predict(:)).^2 );
% %fprintf('test fit SSD: %d\n', ssd);
% [R,P] = corrcoef(actual, predict)
% 
% plotPredictVsData(outputData_Y, predict, test);  % data_y, pred_y, pred_x

%figure;
%disp(length(outputData_Y));
%disp(length(data_predict));
%compare(outputData_Y, data_predict);

% NOTE: in it's current form these predictions are way off, tegressors are
% not scaled based on the number of lag terms (but that doesn't fully
% explain the prediction problem), and only one time series is considered.