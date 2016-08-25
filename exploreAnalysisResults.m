addpath violin

% explores results of data analysis
load('analysisData');
% assumed data cols: trainTestRatio, randSeed, NRMSE, PID, conditionNum,
% usedInputsColumnsBits
n_cols = 5;
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
title('condition # histogram');
xlim(condLimits);
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
ylabel('cond#');
ylim(condLimits);


behavARXExplore.scatter(analysisData, 'n_chunks', 'NRMSE');

behavARXExplore.violinPlot(analysisData);

behavARXExplore.printBest(analysisData);
