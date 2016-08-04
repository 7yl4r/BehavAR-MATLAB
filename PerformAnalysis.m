function [ ] = PerformAnalysis( N )
% PerformAnalysis runs behavARX on all participants N times.

defaultRandSeed = 1;

% pick up where we left off (if partial analysis exists)
if exist('analysisData.mat', 'file') == 2
    load('analysisData');
    %randSeed = analysisData(end,2);  % use last seed
    randSeed = max(analysisData(:,2)); % use max seed (better than last)
    fprintf('Resuming analysis @ seed value %d\n', randSeed);
else 
    fprintf('No data file found; starting new analysis\n');
    analysisData = [];
    randSeed = defaultRandSeed;
end

% load real data
load 'data/linearInterp_v7.0.mat';

pids = unique(data(:,1));
% run behavARX many times on each participant, record results
for i=1:length(pids)
    fprintf('=== p#%d (%d/%d) ===\n',pids(i), i, length(pids));
    analysisData = AnalyzeParticipant(pids(i), data, analysisData, N, randSeed);
end;
fprintf('\n');


end

