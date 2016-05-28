% fake data:
exogeneous_U = mockInputData(500, 'random');  
mockSys = idpoly([1, 0, 0], [.2, .5, .1]);  % mock arx model
outputData_Y = sim(mockSys, exogeneous_U);

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

Adiff = mockSys.a - sys.a;
Bdiff = mockSys.b - sys.b;
disp('actual vs learned coeffs:');
disp('A-A`=')
disp(Adiff)
disp('B-B`=')
disp(Bdiff)

disp('GoF metrics:');
prediction = sim(sys, exogeneous_U);

ssd = sum( (outputData_Y(:) - prediction(:)).^2 );
fprintf('test fit SSD: %d\n', ssd);

[R,P] = corrcoef(outputData_Y, prediction);
fprintf('R=%d\n', R(2));

figure;
showConfidence(bodeplot(sys))
