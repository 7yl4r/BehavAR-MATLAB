classdef ARXResults_test
    %behavARX_test
    
    properties
    end
    
    methods(Static)        
        function testAddResults()
            res = ARXResults();
            res.rowProps('NRMSE', 50);
            res.rowProps('PID', 100009);
            res.finishRow();
            disp(res.data);
        end  % /function testAddResults
        
        function testAppendData()
            res = ARXResults();
            res.appendData([1:6]);
        end
    end  %/static methods
end
