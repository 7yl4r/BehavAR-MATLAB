function [ u ] = mockInputData( len, type)
%getFakeData returns fake input data of various types

if strcmp(type, 'line')
    u = (1:len)';
else % realistic-looking, random data
    u = exp(randn(1, len))';  
end

end

