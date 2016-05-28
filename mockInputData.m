function [ u ] = mockInputData( len, type)
%getFakeData returns fake input data of various types

if strcmp(type, 'line')
    u = (1:len)';  % test line
else
    u = exp(randn(1, len))';  % realistic-looking data
end

end

