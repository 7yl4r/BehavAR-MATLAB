function [  ] = plotTrainTest( data, train, trainY, test, testY )
%plotTrainTest show training and test data points
%   Detailed explanation goes here

% 
figure;
plot(1:length(data), data, ...
    train, trainY, 'go', ...
    test, testY, 'rx');
%print('train-test','-dpng');

end

