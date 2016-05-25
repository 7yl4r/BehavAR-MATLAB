% arx model found by linear least squares as outlined by
% "System Identification" by Lennart Ljung (1995) section 1.3
% link: http://ece.ut.ac.ir/Classpages/S88/ECE150/
%       Papers/Identification--General/ljung95system_C57.pdf
% retrieved: 2016-05

% fake data:
inp = exp(randn(1, 101))';  % u
out = exp(randn(1, 101))';  % y
data = [inp out];

% assert data_series are all same len
% figure;
% plot(inp);

% compute regressor terms for each lag and each data point
lags = [1 2 10];

N = 5;  % last time index of train data
u = inp;
y = out;
phi = []; 

% output terms
for n = 1:N
    if ( N-n > 0)
        phi(length(phi)+1) = -y(N-n);
    else
        phi(length(phi)+1) = -y(1);
    end
end

% input terms
for n = 1:N
    if ( N-n > 0)
        phi(length(phi)+1) = u(N-n);
    else
        phi(length(phi)+1) = u(1);
    end
end

theta = leastSquaresThetas(phi, y, N);

y_t_plus_1 = phi(N+1)*theta;

% NOTE: theta here should be a matrix? but it isn't. =/
