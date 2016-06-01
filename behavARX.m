function [ sys, Y, X ] = behavARX( data,nb )
% This function estimates the model
% y(t) = b_0*u(t) + b_1*u(t-1) ... + b_nb*u(t-nb) +
%      - a_0*y(t) - a_1*y(t-1) ... - a_na*y(t-na)
%
% given y(1),...,y(N),u(1),....,u(N) and using the least squares estimator
%
%  theta=(X^T*X)^(-1)*X^TY
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

disp('behavARX');

y=data.y; % extracts the output signal from the iddata object
u=data.u; % extracts the input signal from the iddata object

N=length(y); % Calculates the number input-output data pairs.

Y=y(nb+1:N); % Builds the output vector of the least squares estimator

% The next lines of code build the regressor matrix of the least squares
% estimator
X=zeros(length(Y),nb+1);
for i=1:length(Y)
     X(i,:) = y(nb+i:-1:i);  % self-correlation regressors
end;
X2=zeros(length(Y),nb+1);
for i=1:length(Y)
    X2(i,:) = u(nb+i:-1:i)';  % input regressors
end;
% X(i,nb+1:2*nb+1) = y(nb+i:-1:i);  % self-correlation regressors
% end of the construction of the regressor Matrix

%[X, X2, Y] = interpolate(X, X2, Y);
[X, X2, Y] = dropNaNs(X, X2, Y);

% The next command calculates the system parameters Theta=(X^T*X)^(-1)X^T*Y
% Notice that (X^T*X)*{-1}*X^T is the pseudo inverse. The command pinv(X)
% calculates the pseudo inverse of X but in MATLAB the most robust way to
% calculate the product pinv(X)*Y is X\Y.
A=X\Y; 
% leading coeff must be exactly 1 (set here removes floating point errors
A(1) = 1;  

B=X2\Y;

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
% disp(A)
% disp(B)

sys=idpoly(A',B');

end

function [X, X2, Y] = interpolate(x, x2, y)
    % interpolate for missing NaN values... (maybe problematic)
    for col=1:size(x,2)
        X(:,col) = naninterp(x(:,col));
    end;
    X(isnan(X)) = 0;  % temp fix for nan vals on edges

    for col=1:size(x2,2)
        X2(:,col) = naninterp(x2(:,col));
    end;
    X2(isnan(X2)) = 0;

    Y = naninterp(y);
    Y(isnan(Y)) = 0;
end

function [xx, xx2, yy] = dropNaNs(x, x2, y)
    % drops rows from the given matricies if nan is in any column
    xx = [];
    xx2= [];
    yy = [];    
    % TODO: there is probably a cleaner way to do this...
    for row=1:size(x,1) 
        if ~any(isnan(x(row,:)))
            xx (length(xx )+1,:)= x (row,:);
            xx2(length(xx2)+1,:)= x2(row,:);
            yy (length(yy )+1,:)= y (row,:);
            %disp('keep row ');
        else
            %disp('drop row ');
        end
            disp(x(row,:));
    end
    xx( ~any(xx,2), : ) = [];  % removed mysterious 0 rows
    xx2(~any(xx2,2),: ) = [];
end
