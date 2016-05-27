function [ y, u ] = getFakeData( len, tao)
%getFakeData returns fake data with relationship delay tao
%   Detailed explanation goes here

%u = (1:len)';  % test line
u = exp(randn(1, len))';  % realistic-looking data
y = zeros(size(u));
for t = 1:length(u)  % fake data with strong autocorrelation
    if t-tao > 0;
        y(t) = u(t-tao)*10 + rand -.5; 
    end
end

end

