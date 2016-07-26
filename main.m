% fake data:
% exogeneous_U = mockInputData(20, 'random');  
% mockSys = idpoly([1, 0, 0], [.2, .5, .1]);  % mock arx model
% outputData_Y = sim(mockSys, exogeneous_U);

% real data
load data_p_263
exogeneous_U = cell2mat(data_p_263(:,4)); % step goal
outputData_Y = cell2mat(data_p_263(:,6)); % actual steps

% split the data
[trainData, testData] = randomSelectionSplit(outputData_Y, exogeneous_U);

plot(trainData);
title('Training Data');
figure;
plot(testData);
title('Validation Data');

% train the arx model
[ sys, Y, X ] = behavARX( trainData, 2 );

figure;
compare(iddata(outputData_Y, exogeneous_U), sys);
title('Model vs Data');

if exist('mockSys', 'var')
    Adiff = mockSys.a - sys.a;
    Bdiff = mockSys.b - sys.b;
    disp('actual vs learned coeffs:');
    disp('A-A`=')
    disp(Adiff)
    disp('B-B`=')
    disp(Bdiff)
end

disp('GoF metrics:');
prediction = sim(sys, exogeneous_U);

ssd = sum( (outputData_Y(:) - prediction(:)).^2 );
fprintf('test fit SSD: %d\n', ssd);

[R,P] = corrcoef(outputData_Y, prediction);
fprintf('R=%d\n', R(2));

figure;
showConfidence(bodeplot(sys))
