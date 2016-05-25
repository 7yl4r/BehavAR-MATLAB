function [ ] = plotRegressorSlopes( train, trainY, regressors, data, taos)
%plotRegressorSlopes show regressor (slope) lines for each train data point
%   Detailed explanation goes here
X = [];
Y = [];
U = [];
V = [];
dt = 1;  % dt used to scale lines

figure;
plot(data, 'Color', [.5 .5 .5]);
hold on;

for tao_i = 1:length(taos)
    %tao = taos(tao_i);
    for i = 1:length(train)
        t = train(i);
        X(i) = t - dt;  % NOTE: X, Y not used.
        U(i) = dt;
        %Y(i) = trainY(i) - trainVals(tao_i, i)*(dt);
        Y(i) = trainY(i) - regressors(tao_i, t)*dt;
        %V(i) = trainVals(tao_i, i)*dt;
        V(i) = regressors(tao_i, t)*dt;

    L = sqrt(U.^2 + V.^2); % vector lengths

    end
    quiver(train, trainY, U./L, V./L, 'AutoScale', 'off');
end
hold off;
end

