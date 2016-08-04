addpath violin

% explores results of data analysis
load('analysisData');
% assumed data cols: trainTestRatio, randSeed, NRMSE, PID, cond_A, cond_B,
% usedInputsColumnsBits
n_cols = 6;


% ### analysis across all data
hist(analysisData(:,1));
figure;
hist(analysisData(:,3));
figure;
hist(analysisData(:,5));
figure;
hist(analysisData(:,6));

% TODO: scatterplots on correlations
% NRMSE vs train/test
figure;
scatter(analysisData(:,3), analysisData(:,1))
% NRMSE vs cond_A
figure;
scatter(analysisData(:,3), analysisData(:,5))
% NRMSE vs cond_B
figure;
scatter(analysisData(:,3), analysisData(:,6))


% ### segmented by participant
% pids = unique(analysisData(:,4));
% segmented_data = [];
% for i=1:length(pids)
%     PID = pids(i);
%     indices = analysisData(:,1) == PID;
%     participant_subset = analysisData(indices,3);
%     segmented_data(i) = participant_subset;
%       % This broken b/c "In an assignment  A(I) = B, the number of 
%       %   elements in B and I must be the same."
%       %   This makes sense, I don't know how to do an array of lists in
%       %   matlab, and a matrix just won't do this.
% end;

% so... I guess I'll write in the PIDs manually...
target_col = 3;
figure;
violin([...
    analysisData(analysisData(:,4) == 100008,target_col)...
    analysisData(analysisData(:,4) == 100057,target_col)...
    analysisData(analysisData(:,4) == 100073,target_col)...
    analysisData(analysisData(:,4) == 100115,target_col)...
    analysisData(analysisData(:,4) == 100123,target_col)...
    analysisData(analysisData(:,4) == 100149,target_col)...
    analysisData(analysisData(:,4) == 100156,target_col)...
    analysisData(analysisData(:,4) == 100164,target_col)...
    analysisData(analysisData(:,4) == 100172,target_col)...
    analysisData(analysisData(:,4) == 100180,target_col)...
    analysisData(analysisData(:,4) == 100198,target_col)...
    analysisData(analysisData(:,4) == 100206,target_col)...
    analysisData(analysisData(:,4) == 100214,target_col)...
    analysisData(analysisData(:,4) == 100222,target_col)...
    analysisData(analysisData(:,4) == 100230,target_col)...
    analysisData(analysisData(:,4) == 100248,target_col)...
    analysisData(analysisData(:,4) == 100255,target_col)...
    analysisData(analysisData(:,4) == 100263,target_col)...
    ]);
