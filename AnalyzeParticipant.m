function [ analysisData ] = AnalyzeParticipant( PID, data, ...
    amountTrain, amountTest, split_type, analysisData, N, randSeed, ...
    showfigs)
%AnalyzeParticpant Performs behavARX analysis on given participant id.
%   # REQUIRED #
%   PID     -    participant id number 
%   data    -    data matrix as described below
%   # OPTIONAL #
%   analysisData - existing saved analysisData or empty obj to save in
%   N   -    number of times to run analysis
%   randSeed - number to seed random function
%   amountTrain - amount of data to use to train (default 80%)
%   amountTest  - amount of data to use to evaluate (default 20%)
%   split_type  - method used to separate train/test sets
%   showfigs    - true to show figures. defaults true
%
%   Assumes given data variable has the following structure:
%       {
%   1   'participant_id',
%       'study_day',
%       'study_date',
%       'goal_steps',               *
%   5   'reward_points',            *
%       'actual_steps',
%       'granted_points',           *
%       'sleep',
%       'busypred',
%   10  'stresspred',
%       'typicalpred',
%       'intrinsicmotivation',
%       'intrinsicurge',
%       'outcome_sleep',
%   15  'outcome_appearance',
%       'outcome_mood',
%       'outcome_concentration',
%       'outcome_fitness',
%       'outcome_other',
%   20  'negativereinforce1',
%       'identity',
%       'habit',
%       'selfcontrol',
%       'commitment',
%   25  'selfefficacygoal',
%       'urge',
%       'feelsLikeAvg',
%       'IsWeekend'
%       }

if ~exist('N', 'var')
    N = 1;
end
if ~exist('randSeed', 'var')
    randSeed = randi([1000 9999]);
end
if ~exist('amountTrain', 'var') || ~exist('amountTest', 'var')
    amountTrain = 4;
    amountTest = 1;
end
if ~exist('split_type', 'var')
    split_type = SplitType.randomChunks;
end
if ~exist('showfigs', 'var')
    showfigs = true;
end

%Find indices to elements in first column of A that satisfy the equality
indices = data(:,1) == PID;

%Use the logical indices to index into A to return required sub-matrices
participant_subset = data(indices,:);

inputModelOrders='0001000000011111111111111100';  % NOTE: right now just shows usage of a var, not the model order...
      
% exogeneous_U = [participant_subset(:,4)];  % step goal

exogeneous_U = [participant_subset(:,4)...% step goal
    participant_subset(:,5)...
    participant_subset(:,7)];  

% multiple inputs (U) 
% exogeneous_U = [participant_subset(:,4),participant_subset(:,12)...
%     participant_subset(:,13), participant_subset(:,14)...
%     participant_subset(:,15), participant_subset(:,16)...
%     participant_subset(:,17), participant_subset(:,18)...
%     participant_subset(:,19), participant_subset(:,20)...
%     participant_subset(:,21), participant_subset(:,22)...
%     participant_subset(:,23), participant_subset(:,24)...
%     participant_subset(:,25), participant_subset(:,26)]; 

outputData_Y = participant_subset(:,6); % actual steps


% run behavARX many times, record results
for i=1:N
    fprintf('%d|',randSeed);
    rng(randSeed);

%     disp('U=')
%     disp(exogeneous_U)

    % 3/5 training chunks = 60% train/test split
    [ trainTestRatio, NRMSE, conditionNum ]...
        = AnalyzeData(outputData_Y, exogeneous_U, amountTrain, amountTest, split_type, 3, showfigs);

    row = [ trainTestRatio, randSeed, NRMSE, PID, conditionNum ];
    
    if exist('analysisData', 'var')
        analysisData = [analysisData; row];
    end
    
    randSeed = randSeed + 1;
end;
fprintf('\n');
if exist('analysisData', 'var')
    save('analysisData', 'analysisData');
end
end

