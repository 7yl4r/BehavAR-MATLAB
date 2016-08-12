function [ sys, theta, conditionNum ] = behavARX( data, nb, verbose)
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

if nargin < 3
    verbose = false;
end

% TODO: could use struc()? to generate model-order combinations?
% http://www.mathworks.com/help/ident/ref/struc.html

y=data.y; % extracts the output signal from the iddata object
u=data.u; % extracts the input signal from the iddata object

% Calculate the number input-output data pairs (size of matrix Y & theta) N
n_inputs = size(u,2)+1;  % +1 b/c autocorrelation
timeSpan = length(y)-nb;  % starting Y with y(nb+1), so nb+1 through len(y)

% fprintf('y(%dx1), nb=%d, # regressors per input=%d, # inputs=%d\n',length(y), nb, timeSpan, n_inputs);
% Builds the output vector Y the least squares estimator
Y = y(nb+1:end);

% Build input matrix U for least squares estimator
X=zeros((nb)*n_inputs, timeSpan);
for i=1:timeSpan
    %  X(i,:) = y(nb+i:-1:i);
%     disp(size( X(1:nb,i) ));
%     disp(size( y(i:nb+i) ));
    % first the autocorrelation
    % no nb b/c Y is shifted so i here is already nb lagged
    % reversed to match up w/ q operator for A & B matrices (see idpoly)
    t0 = i;
    tf = nb+i-1;
    X(1:nb,i) = -y(tf:-1:t0);
    
    % next the input-output correlation
    for inpNum = 1:size(u,2)
        lag0_i = nb*inpNum+1;
        lagf_i= nb*(inpNum+1);
        X(lag0_i:lagf_i, i) = u(tf:-1:t0,inpNum);
    end
end
% next the input-output correlation
% for inpNum = 1:size(u,2)
%     %  X2(i,:) = u(nb+i:-1:i)';  % NOTE: notes above apply here too
%     for i = 1:timeSpan
%         X_ind = inpNum*timeSpan + i;
% %         disp(size(X(X_ind,:)));
% %         disp(size(u(nb+i:-1:i, inpNum)'));
%         X(nb*inpNum:nb*(inpNum+1), X_ind) = u(nb+i:-1:i,inpNum);
%     end
% end

%[X, Y] = interpolate(X, Y);
if verbose
    fprintf('Y[%d,%d]=X[%d,%d]T[?,?]\n',size(Y),size(X));
end

[X, Y] = dropNaNs(X, Y);

if verbose
    fprintf('\n');
    disp('after trimmming NaNs');
    fprintf('Y[%d,%d]=X[%d,%d]T[?,?]\n',size(Y),size(X));
    X
    Y
end

X = X';  % oops, X is sideways

conditionNum = cond(X); 

if verbose
    conditionNum
end

% disp(X);

% TODO: choose to do something about poorly conditioned X...

% The next command calculates the system parameters Theta=(X^T*X)^(-1)X^T*Y
% Notice that (X^T*X)*{-1}*X^T is the pseudo inverse. The command pinv(X)
% calculates the pseudo inverse of X but in MATLAB the most robust way to
% calculate the product pinv(X)*Y is X\Y.
theta=X\Y; 
% theta=pinv(X)*Y;
% theta=inv(X'*X)*X'*Y;

%size checks
% fprintf('Y[%d,%d]=X[%d,%d]T[%d,%d]',size(Y),size(X),size(theta));

if verbose
    theta
    % theta should look like:
    % out1(t-1)->out1(t)
    % out1(t-2)->out1(t)
    % in1(t-1)->out1(t)
    % in2(t-2)->out1(t)
end

% check that there wasn't 0 data
if length(theta) < 1 || any(isnan(theta))
    theta = zeros(nb*n_inputs, 1);
    disp('WARN: not enough non-NaN data to form regressor matrix'); 
end

N_y = size(y,2);
N_u = size(u,2);

% A = first timeSpan rows of theta, B = last rows
A = cell(N_y, N_y);
A{1,1} = [1; theta(1:nb)];

%     % multi-input should be something like this...
%     for y_i = 1:size(y,2)
%         for y_j = 1:size(y,2)
%             Arow = zeros(size(y,2));
%             if y_i == y_j
%                 Arow(y_i,y_j) = 1;
%             else
%                 Arow
%             end
%             A{y_i, y_i} 
%         end
%         A{y_i,y_j} = Arow;
%     end
%     A = [1; theta(1:nb)];

B = cell(N_y, N_u);
for inNum = 1:N_u  % todo: multi-out i.e. B{outNum,inNum} =
    B{1,inNum} = [0; theta( (inNum*nb+1) : (inNum+1)*nb)];  % in1->out1
end

% fprintf('A[%d,%d]q y(t) = B[%d,%d]q u(t)',size(A),size(B));
% theta
% cell2mat(A)
% cell2mat(B)

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

sys=idpoly(A,B);


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
    % drops columns from x and rows from y if nan is in them
    % assumes size(y,1) == size(x,2)
    xx = [];
    yy = [];    
    % TODO: there is probably a cleaner way to do this...
    for row=1:size(y,1) 
%         fprintf('%d || %d', y(row), x(:,row));
        if ~isnan(y(row)) && ~any(isnan(x(:,row)))
            xx (:,size(xx,2)+1) = x (:,row);
            yy (size(yy,1)+1,:) = y (row,:);
%             disp('keep row ');
        else
%             disp('drop row ');
        end
    end
%     xx( ~any(xx,2), : ) = [];  % removed mysterious 0 rows
end
