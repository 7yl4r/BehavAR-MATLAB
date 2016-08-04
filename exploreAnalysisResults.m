addpath violin

% explores results of data analysis
load('analysisData');
% assumed data cols: trainTestRatio, randSeed, NRMSE, PID, cond_A, cond_B,
% usedInputsColumnsBits
n_cols = 6;
trainTestLimits = [0 100];
NRMSELimits = [-100 100];
condLimits = [0 100];

% threshold large neg %fit values
index = 3;
analysisData( (analysisData(:,index) < NRMSELimits(1)), index ) = NRMSELimits(1);
analysisData( (analysisData(:,index) > NRMSELimits(2)), index ) = NRMSELimits(2);

index = 5;
analysisData( (analysisData(:,index) < condLimits(1)), index ) = condLimits(1);
analysisData( (analysisData(:,index) > condLimits(2)), index ) = condLimits(2);

index = 6;
analysisData( (analysisData(:,index) < condLimits(1)), index ) = condLimits(1);
analysisData( (analysisData(:,index) > condLimits(2)), index ) = condLimits(2);



% ### analysis across all data
hist(analysisData(:,1));
title('trainTest histogram');
% xlim(trainTestLimits);
% xlabel();
% ylabel();

figure;
hist(analysisData(:,3));
title('NRMSE histogram');
xlim(NRMSELimits);
% xlabel();
% ylabel();

figure;
nBins = 10;
stepSize = (condLimits(2)-condLimits(1))/(nBins-1);
centers = condLimits(1):stepSize:condLimits(2);
Xcts = hist(analysisData(:,5), centers);
[xb, yb] = stairs(centers,Xcts);
area(xb, yb)
title('cond_A histogram');
xlim(condLimits);
% xlabel();
% ylabel();

figure;
nBins = 10;
stepSize = (condLimits(2)-condLimits(1))/(nBins-1);
centers = condLimits(1):stepSize:condLimits(2);
Xcts = hist(analysisData(:,6), centers);
[xb, yb] = stairs(centers,Xcts);
area(xb, yb)
title('cond_B histogram');
ylim(condLimits);
% xlabel();
% ylabel();

figure;
scatter(analysisData(:,3), analysisData(:,1))
% title();
xlabel('NRMSE');
xlim(NRMSELimits);
ylabel('% train');
% ylim(trainTestLimits);

figure;
scatter(analysisData(:,3), analysisData(:,5))
% title();
xlabel('NRMSE');
xlim(NRMSELimits);
ylabel('cond(A regressors) (auto-correlation vals)');
ylim(condLimits);

figure;
scatter(analysisData(:,3), analysisData(:,6))
% title();
xlabel('NRMSE');
xlim(NRMSELimits);
ylabel('cond(B regressors) (in-out correlations)');
ylim(condLimits);

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
% title();
xlabel('participant');
ylabel('NRMSE');
ylim(NRMSELimits);

% best of each participant
pids = unique(analysisData(:,4));
% run behavARX many times on each participant, record results
best = zeros(length(pids), size(analysisData,2));
for i=1:length(pids)
    pid = pids(i);
    p_data = analysisData(analysisData(:,4) == pid,:);
    [val, ind ] = max(p_data(:,3));
    best(i,:) = p_data(ind, :);
end;
printmat(best, 'Best Models', '100008 100057 100073 100115 100123 100149 100156 100164 100172 100180 100198 100206 100214 100222 100230 100248 100255 100263', 'trainTestRatio randSeed NRMSE PID cond_A cond_B');


