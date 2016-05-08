function [ ] = plotRegressorSlopes( train, trainY, trainVals, data)
%plotRegressorSlopes show regressor (slope) lines for each train data point
%   Detailed explanation goes here
X = [];
Y = [];
U = [];
V = [];
dt = 1;  % dt used to scale lines
tao = 1;  % TODO: support multiple tao values
for i = 1:length(train)
    t = train(i);
    X(i) = t - dt;  % NOTE: X, Y not used.
    U(i) = dt;
    Y(i) = trainY(i) - trainVals(tao, i)*(dt);
    V(i) = trainVals(tao, i)*dt;

L = sqrt(U.^2 + V.^2); % vector lengths

end
figure;
plot(data, 'Color', [.5 .5 .5]);
hold on;
quiver(train, trainY, U./L, V./L, 'Color', 'r', 'AutoScale', 'off');
hold off;
end

