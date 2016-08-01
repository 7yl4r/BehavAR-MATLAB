% explores results of data analysis
load('analysisData');

% data cols: [ trainTestRatio, randSeed, NRMSE, PID, cond_A, cond_B ]
hist(analysisData(:,1));
figure;
hist(analysisData(:,3));
figure;
hist(analysisData(:,5));
figure;
hist(analysisData(:,6));

% NRMSE vs train/test
corrcoef(analysisData(:,3), analysisData(:,1))

% NRMSE vs cond_A
corrcoef(analysisData(:,3), analysisData(:,5))

% NRMSE vs cond_B
corrcoef(analysisData(:,3), analysisData(:,6))