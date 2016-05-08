function [ regressors ] = getRegressors( data, lags )
%getRegressors compute regressor matrix using given input for each lag term
%   ...

regressors = zeros(length(lags), length(data));

for t = 1:length(data)
    
    % x(t) = ax(t-1) + b
    % a = (x(t) - b ) / x(t-1)
    b = 0;  % regressor intercept
    
    % compute regressor for each time-lag
    for tao = 1:length(lags)
        if t-tao > 0
            regressors(tao, t) = ...
                (data(t) - data(t-tao))/tao;
                %(data_series1(t) - b) / data_series1(t-tao);
        else
            regressors(tao, t) = 0;
        end  % else t-tao is out-of-bounds
    end
end

fprintf('computed %d regressors (%d lag terms x %d datapoints)\n', ...
    numel(regressors), size(regressors)); 

end

