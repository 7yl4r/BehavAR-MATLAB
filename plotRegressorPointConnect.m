function [ output_args ] = plotRegressorPointConnect( train, trainY, data )
%plotRegressorPointConnect show slopes by connecting points x(t-tao) to (t)
%   Detailed explanation goes here

tao = 1;  % TODO: support multiple taos
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
figure('Name', 'training point-connections');
plot(data, 'Color', [.5 .5 .5]);
hold on;
quiver(train, trainY, U./L, V./L, 'Color', 'r', 'AutoScale', 'off');
hold off;

end

