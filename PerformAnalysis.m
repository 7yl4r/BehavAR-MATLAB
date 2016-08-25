function [ ] = PerformAnalysis( N, split_type, amountTrain, amountTest )
% PerformAnalysis( N ) runs behavARX on all participants N times.
% optional positional args for
% PerformAnalysis(N, splitType, amountTrain, amountTest)
% * splitType : SplitType enum describes data split method
% * amountTrain : amount to use for training (format depends on splitType)
% * amountTest  : amount to use for test (format dep. on splitType)

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
    analysisData = AnalyzeParticipant(pids(i), data, ...
        amountTrain, amountTest, split_type, analysisData, N, randSeed, false);
end;
fprintf('\n');


end

