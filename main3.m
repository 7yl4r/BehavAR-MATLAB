% fake data:
data_series1 = exp(randn(1, 101))';
data_series2 = exp(randn(1, 101))';
data = [data_series1 data_series2];

% assert data_series are all same len
% figure;
% plot(data_series1);

% compute regressor terms for each lag and each data point
lags = [1 2 10];

regressors = getRegressors(data_series1, lags);

[train, test, trainY, testY, trainVals, testVals] = ...
    splitRegressors(regressors, data_series1);

plotTrainTest( data_series1, train, trainY, test, testY );

%plotRegressorSlopes(train, trainY, trainVals, data_series1, lags);
plotRegressorSlopes(train, trainY, regressors, data_series1, lags);

plotRegressorPointConnect(train, trainY, data_series1, lags);

% use train regressors to do autoregression
sums = zeros(1, length(lags));  % sum of train regressors
avgs = zeros(1, length(lags));
for i = 1:length(train)
    t = train(i);  % time index of selected train item
    for tao = 1:length(lags)
        sums(tao) = regressors(tao, t) + sums(tao);
    end
end

for tao = 1:length(lags)
    avgs(tao) = sums(tao)/length(train);
end
fprintf('\t=== avg regressors ===\n');
fprintf('lags: ');
fprintf('\t%8.0f', lags);
fprintf('\n');
fprintf('rhos: ');
fprintf('\t%3.2d', avgs);
fprintf('\n');

% compute predictions from all data
data_predict = zeros(length(data_series1));
for t = 1:length(data_series1)
    data_predict(t) = 0;
    for tao = 1:length(lags)
        if t-tao > 0
            data_predict(t) = data_predict(t) ...
                + avgs(tao)*data_series1(t-tao);
        end
    end
end

% evaluate data on test set
actual = zeros(length(test));
predict= zeros(length(test));
for i = 1:length(test)
    t = test(i);  % time index of selected train item
    actual(i) = data_series1(t);
    predict(i)= data_predict(t);
end

%ssd = sum( (actual(:) - predict(:)).^2 );
%fprintf('test fit SSD: %d\n', ssd);
[R,P] = corrcoef(actual, predict)

plotPredictVsData(data_series1, predict, test);  % data_y, pred_y, pred_x

%figure;
%disp(length(data_series1));
%disp(length(data_predict));
%compare(data_series1, data_predict);

% NOTE: in it's current form these predictions are way off, tegressors are
% not scaled based on the number of lag terms (but that doesn't fully
% explain the prediction problem), and only one time series is considered.