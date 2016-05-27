% fake data
len = 20;
tao = 1;
[y, u] = getFakeData(len, tao);  % min len is 4 + tao

ny = size(y, 2);  % # of inputs
nu = size(u, 2);  % # of outputs

if(size(u, 1) ~= size(y, 1))
    printf('size of input and output mismatched');
end

z3 = iddata(y, u, 1);
disp(z3)
figure;
plot(z3)
na = 1;  % Order of the polynomial A(q)
nb = 1;  % Order of the polynomial A(q)
nk = tao;  % Input-output delay expressed as fixed leading zeros of B 

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