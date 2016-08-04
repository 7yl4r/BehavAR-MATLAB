% fake data:
% exogeneous_U = mockInputData(20, 'random');  
% mockSys = idpoly([1, 0, 0], [.2, .5, .1]);  % mock arx model
% outputData_Y = sim(mockSys, exogeneous_U);

% pick up where we left off (if partial analysis exists)
if exist('analysisData.mat', 'file') == 2
    load('analysisData');
    %randSeed = analysisData(end,2);  % use last seed
    randSeed = max(analysisData(:,2)); % use max seed (better than last)
    fprintf('Resuming analysis @ seed value %d\n', randSeed);
else 
    fprintf('No data file found; starting new analysis\n');
    analysisData = [];
    randSeed = 1;
end

% load real data
load 'data/linearInterp_v7.0.mat';

pids = unique(data(:,1));
% run behavARX many times on each participant, record results
for i=1:length(pids)
    fprintf('=== p#%d ===\n',pids(i));
    analysisData = AnalyzeParticipant(pids(i), data, analysisData, 1, randSeed);
end;
fprintf('\n');


