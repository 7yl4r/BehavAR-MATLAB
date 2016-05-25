function [ theta ] = leastSquaresThetas( phi, y, N)
%leastSquaresThetas returns array of 
%   Detailed explanation goes here

numerator = 0;
for t = 1:N
    numerator = numerator + phi(t)*phi(t).';
end

denominator = 0;
for t = 1:N
    denominator = denominator + phi(t)*y(t);
end

theta = numerator/denominator;

end

