function [ output_args ] = ...
    plotRegressorPointConnect( train, trainY, data , taos)
%plotRegressorPointConnect show slopes by connecting points x(t-tao) to (t)
%   Detailed explanation goes here

figure('Name', 'training point-connections');
plot(data, 'Color', [.5 .5 .5]);
hold on;

for tao_i = 1:length(taos)
    tao = taos(tao_i);
    X = [];
    Y = [];
    U = [];
    V = [];
    for i = 1:length(train)
        t = train(i);
        if (t-tao > 0)
            X(i) = t-tao;
            Y(i) = data(t-tao);
            U(i) = tao;
            V(i) = data(t) - data(t-tao);
        else
            X(i) = 0;
            Y(i) = 0;
            U(i) = 0;
            V(i) = 0;
        end
    
    L = sqrt(U.^2 + V.^2); % vector lengths

    end

    quiver(train, trainY, U./L, V./L, 'AutoScale', 'off');
end
hold off;
end

