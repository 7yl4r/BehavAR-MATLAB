function [ analysisData ] = AnalyzeParticipant( PID, data, analysisData, N, randSeed)
%AnalyzeParticpant Performs behavARX analysis on given participant id
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

%Find indices to elements in first column of A that satisfy the equality
indices = data(:,1) == PID;

%Use the logical indices to index into A to return required sub-matrices
participant_subset = data(indices,:);

inputModelOrders='0001000000011111111111111100';  % NOTE: right now just shows usage of a var, not the model order...
      
% exogeneous_U = [participant_subset(:,4)];  % step goal

exogeneous_U = [participant_subset(:,4)...
    participant_subset(:,5)...
    participant_subset(:,7)];  % step goal

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
        = AnalyzeData(outputData_Y, exogeneous_U, .6, 3, false);

    row = [ trainTestRatio, randSeed, NRMSE, PID, conditionNum ];
    
    analysisData = [analysisData; row];
    
    randSeed = randSeed + 1;
end;
fprintf('\n');

save('analysisData', 'analysisData');
end

