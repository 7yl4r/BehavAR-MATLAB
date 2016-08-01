% fake data:
% exogeneous_U = mockInputData(20, 'random');  
% mockSys = idpoly([1, 0, 0], [.2, .5, .1]);  % mock arx model
% outputData_Y = sim(mockSys, exogeneous_U);

% real data
load data_p_263
PID = 263;
exogeneous_U = cell2mat(data_p_263(:,4)); % step goal
outputData_Y = cell2mat(data_p_263(:,6)); % actual steps
% TODO: multiple inputs (U) 

if exist('analysisData', 'file') == 1
    analysisData = load('analysisData');
else 
    analysisData = [];
end

randSeed = 101;

% run behavARX many times, record results
for i=1:500
    fprintf('%d|',i);
     rng(randSeed);

    [ trainTestRatio, NRMSE, cond_A, cond_B ]...
        = AnalyzeData(exogeneous_U, outputData_Y, false);

    row = [ trainTestRatio, randSeed, NRMSE, PID, cond_A, cond_B ];
    
    analysisData = [analysisData; row];
    save('analysisData', 'analysisData');
    
    randSeed = randSeed + 1;
end;


