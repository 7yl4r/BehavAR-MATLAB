%load iddata3 z3 % estimation data
len = 5;
u1 = exp(randn(1, len))';
u2 = exp(randn(1, len))';
y = zeros(size(u1));
tao = 1;
for t = 1:length(u1)  % fake data with strong autocorrelation
    if t-tao > 0;
        y(t) = u1(t-tao)*10 + rand;
    end
end

%y = [1 2 3 5 10 20].';
%u1 = [0 1 2 4 9 15].';
%u2 = [1 2 3 4 5 6].';

u = [u1, u2];  % is u time or input signal?
u = u1;

ny = size(y, 2);  % # of inputs
nu = size(u, 2);  % # of outputs

if(size(u, 1) ~= size(y, 1))
    printf('size of input and output mismatched');
end

z3 = iddata(y, u, 1);
disp(z3)
figure;
plot(z3)
na = 1;
nb = 1;
nk = 1;

% # rows of na, nb, nk == # outputs rows of u (ny) 
% na is square (ny by ny)
% nb && nk are ny x nu

Orders = [na nb nk]; 
[Lambda, R] = arxRegul(z3, Orders, 'DC');
Opt = arxOptions;
Opt.Regularization.Lambda = Lambda;
Opt.Regularization.R = R;
model1 = arx(z3, Orders)      % unregularized estimate 
model2 = arx(z3, Orders, Opt) % regularized estimate
% Compare fits and confidence bounds on frequency response
figure;
compare(z3, model1, model2)
figure;
%disp(model1);
%disp(model2);
showConfidence(bodeplot(model1,model2))