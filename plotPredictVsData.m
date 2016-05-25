function [ ] = plotPredictVsData( data_y, pred_y, pred_x )
%plotPredictVsData Plots data along with predicted data points
%   Detailed explanation goes here

figure;
plot(1:length(data_y), data_y, ...
    pred_x, pred_y, 'rx');
%print('train-test','-dpng');

end

