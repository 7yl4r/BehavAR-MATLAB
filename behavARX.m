function [ sys, Y, X, conditionNum ] = behavARX( data, nb, verbose)
% This function estimates the model
% y(t) = b_0*u(t) + b_1*u(t-1) ... + b_nb*u(t-nb) +
%      - a_0*y(t) - a_1*y(t-1) ... - a_na*y(t-na)
%
% Y = BU - AY ?
%
% given y(1),...,y(N),u(1),....,u(N) and using the least squares estimator
%
%  theta=(X^T*X)^(-1)*X^TY  % this is normal equation
%
% TODO: check condition of X^T*X
%   if ill-conditioned, you get errors 10^k digits lost
%   if singular, non-invertable.
%
% where 
%   theta=[b_0 ... b_nb]^T
%   Y=[y(nb+1) ... y(N)]
%   X=[u(nb+1)  u(nb)  ...   u(1)
%      u(nb+2) u(nb+1) ...   u(2)
%      ..........................
%       u(N)    u(N-1) ... u(N-nb)] 
% 
% the first element of Y isn't y(1) because the first row of X would have
% to be [u(1) u(0) u(-1) ... u(1-nb)] and u(0), u(-1), ... u(1-nb) are not
% available. By starting Y with y(nb+1) one ensures that all values of X
% (u(1) to u(N)) are available.
%
% This function has the following inputs:
%  data - iddata object containing the input/output data. This object must
%  be externally built with the iddata command, p.e.
% data=iddata(y,u)
% where y and u are column vectors (or matrices in the case of
% muiltivariable systems) containing the output and input signals. As this
% function only considers single input single output (SISO) systems y and u
% must be column vectors.
% nb - system order, i.e., the maximal lag in the model.
%
% Outputs:
%   sys - idpoly object with the estimated model (see the MATLB command
%   idpoly for a description of idpoly objects)
%   Y  - Output vector of the least squares estimator
%   X - regressor matrix of the least squares estimator.
%
% In your problem you will use an output vector and regressor matrix 
% consisting on random permutations of rows of X and Y.

y=data.y; % extracts the output signal from the iddata object
u=data.u; % extracts the input signal from the iddata object

% Calculate the number input-output data pairs (size of matrix Y & theta) N
n_inputs = size(u,2)+1;  % +1 b/c autocorrelation
timeSpan = length(y)-nb;  % starting Y with y(nb+1), so nb+1 through len(y)
N=timeSpan*(n_inputs); % one set of outputs for each input

fprintf('y(%dx1), nb=%d, # regressors per input=%d\n',length(y), nb, timeSpan);
% Builds the output vector Y the least squares estimator
Y=zeros(N,1); 
for inpNum = 1:n_inputs
    % Y = y(nb+1:length(y));
    Y((inpNum-1)*timeSpan+1 : inpNum*timeSpan) = y(nb+1:length(y));
end

% Build input matrix U for least squares estimator
X=zeros(N,n_inputs);
% first the autocorrelation
for i=1:timeSpan
    %  U(i,:) = y(nb+i:-1:i);  % NOTE: now only using 1 delay, not
    %  range from t-1 : t-nb (like this old code snippet did)
    X(i) = y(i);  % no nb b/c Y is shifted so i here is already nb lagged
end
% next the input-output correlation
for inpNum = 1:size(u,2)
    %  X2(i,:) = u(nb+i:-1:i)';  % NOTE: notes above apply here too
    for i = 1:timeSpan
        X_ind = inpNum*timeSpan + i;
        X(X_ind) = u(i,inpNum);
    end
end

%[X, Y] = interpolate(X, Y);
[X, Y] = dropNaNs(X, Y);

conditionNum = cond(X); 

% TODO: choose to do something about poorly conditioned X...

% The next command calculates the system parameters Theta=(X^T*X)^(-1)X^T*Y
% Notice that (X^T*X)*{-1}*X^T is the pseudo inverse. The command pinv(X)
% calculates the pseudo inverse of X but in MATLAB the most robust way to
% calculate the product pinv(X)*Y is X\Y.
theta=X\Y; 
% leading coeff must be exactly 1 (set here removes floating point errors
% theta(1) = 1;  

%size checks
%fprintf('Y[%d,%d]=X[%d,%d]T[%d,%d]',size(Y),size(X),size(theta));

% A = first timeSpan rows of theta, B = last rows
A = theta(1:timeSpan);
B = zeros(size(u,2), size(y,1) );
for inNum = 1:size(u,2);
    B(inNum, :) = theta(inNum*timeSpan:(inNum+1)*timeSpan);
end

% The next command builds an idpoly model A(q^-1)y(t)=B(q^-1)u(t) with
% A(q^-1)=1 and the coefficients of B(q^-1) in theta. The q^-1 is the delay
% operator and A(q^-1) and B(q^-1) are polynomials of q^-1, i.e.,
% A(q^-1)=1+a_1*q^-1+...+a_na*q^-na
% B(q^-1)=b_0+b_1*q^-1+...+b_nb*q^-nb
% The model
%
% A(q^-1)y(t)=B(q^-1)u(t)
%
% is a compact form of describing
%
% y(t)+a_1*y(t-1)+...+a_na*y(t-na)=b_0*u(t)+b_1*u(t-1)+...+b_nb*u(t-nb)
%
% Using the delay operator
%
% y(t)+a_1*q^-1y(t)+...a_na*q^-na*y(t)=b_0*u(t)+b_1*q^-1u(t)+...+b_nb*q^-nb*u(t)
%
% putting y(t) and u(t) in evidence in the left and right sizes
%
% (1+a_1*q^-1+...+a_na*q^-na)*y(t)=(b_0+b_1*q^-1+...+b_nb*q^-nb)*u(t)
%
% you get the referred compact form .
% disp('A')
% disp(A)
% disp('B')
% disp(B)

sys=idpoly(A',B');


end

function [X, Y] = interpolate(x, y)
    % interpolate for missing NaN values... (maybe problematic)
    for col=1:size(x,2)
        X(:,col) = naninterp(x(:,col));
    end;
    X(isnan(X)) = 0;  % temp fix for nan vals on edges

    Y = naninterp(y);
    Y(isnan(Y)) = 0;
end

function [xx, yy] = dropNaNs(x, y)
    % drops rows from the given matricies if nan is in any column
    xx = [];
    yy = [];    
    % TODO: there is probably a cleaner way to do this...
    for row=1:size(x,1) 
        if ~any(isnan(x(row,:)))
            xx (length(xx )+1,:)= x (row,:);
            yy (length(yy )+1,:)= y (row,:);
            %disp('keep row ');
        else
            %disp('drop row ');
        end
%             disp(x(row,:));
    end
    xx( ~any(xx,2), : ) = [];  % removed mysterious 0 rows
end
