function [ ] = PerformAnalysis( N, filename, split_type, amountTrain, amountTest)
% PerformAnalysis( N ) runs behavARX on all participants N times.

if ~exist('split_type', 'var')
    split_type = SplitType.randomChunks;
end
if ~exist('amountTrain', 'var')
    amountTrain = 2;
end
if ~exist('amountTest', 'var')
    amountTest = 1;
end

defaultRandSeed = 1;

% pick up where we left off (if partial analysis exists)
if exist(filename, 'file') == 2
    load(filename, 'results');
    %randSeed = analysisData(end,2);  % use last seed
    randSeed = max(analysisData(:,2)); % use max seed
    fprintf('Resuming analysis @ seed value %d\n', randSeed);
else 
    fprintf('starting new analysis\n');
    results = ARXResults();
    randSeed = defaultRandSeed;
end

% load real data. expected vars: data
load 'data/linearInterp_v7.0.mat';

pids = unique(data(:,1));
% run behavARX many times on each participant, record results
for i=1:length(pids)
    fprintf('=== p#%d (%d/%d) ===\n',pids(i), i, length(pids));
    results = AnalyzeParticipant(pids(i), data, ...
        amountTrain, amountTest, split_type, results, N, ...
        randSeed, false);
end;
fprintf('\n');

save(filename, 'results');
end

