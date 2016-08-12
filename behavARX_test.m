classdef behavARX_test
    %behavARX_test
    
    properties
    end
    
    methods(Static)
        
        function [] = testBuiltInAndCustomYieldSimilar()
            [modelOrder, trainData, outputData_Y, exogeneous_U, mockSys] = behavARX_test.getKnownMultiInputData();
            [ sys, theta, conditionNum ] = behavARX( trainData, modelOrder, true);
            sys2 = arx(trainData, [modelOrder, [modelOrder modelOrder], [1 1]]);
            compare(trainData, sys);
            title('behavARX');
            figure;
            compare(trainData, sys2);
            title('arx');
            % Use "polydata", "getpvec", "getcov" for parameters and their uncertainties.
            disp('behavARX vs ARX polys:');
            sys
            sys2
            cell2mat(polydata(sys))
            cell2mat(polydata(sys2))
        end
        
        function [] = testXandYasExpected()
            % evaluate the behavARX X & Y matrix building by using known
            %   u & y and checking X & Y.
            Y = 1:10;
            U = 11:10:101;
            nb = 2;
            trainData = iddata(Y', U');
            [ sys, theta, conditionNum ] = behavARX( trainData, nb, true );
            % TODO: print expected X & Y to compare
            %Y_arx = [Y(nb+1):end];
            %X = [Y(
            % expected X = 
%                  2     1    21    11
            %      3     2    31    21
            %      4     3    41    31
            %      5     4    51    41
            %      6     5    61    51
            %      7     6    71    61
            %      8     7    81    71
            %      9     8    91    81
            % expected Y = 
%                  3
%                  4
%                  5
%                  6
%                  7
%                  8
%                  9
%                 10
        end

        function [] = testBuiltInARXTrainKnownModel()
            % tests built-in arx method (to evaluate test method validity)
            showFigures=false;
            modelOrder = 3;
            exogeneous_U = mockInputData(5000, 'random');
            
            A = cell(1,1);
            A{1,1} = [1 0 0 0];  % out1 to out1 t-0 t-1 t-2 t-3
            
            B = cell(1, 1);
            B{1,1} = [0 0 0 .5]; %in1 to out1 t-1 t-2 t-3
            
            mockSys = idpoly(A, B);  % mock arx model
            outputData_Y = sim(mockSys, exogeneous_U);
            
            trainData = iddata(outputData_Y, exogeneous_U);
            
            sys = arx(trainData, [modelOrder, modelOrder, 1]);
            disp('A');
            sys.a
            disp('B');
            sys.b
            
            [~,NRMSE,~] = compare(iddata(outputData_Y, exogeneous_U), sys);
            if showFigures == true
                figure;
                compare(iddata(outputData_Y, exogeneous_U), sys);
                title('Model vs Data');
            end
            if exist('mockSys', 'var')
                Adiff = mockSys.a - sys.a;
                Bdiff = mockSys.b - sys.b;
                disp('actual vs learned coeffs (should be near 0):');
                disp('A-A`=')
                disp(Adiff)
                disp('B-B`=')
                disp(Bdiff)
            end
            NRMSE
        end
        
        function [] = testTrainOnKnownMultiInput()
            % train on known multi-input model
            % test 2 evaluation of the behavARX by training on a known model.
            showFigures = false;  % set to true if you want to see plots

            [modelOrder, trainData, outputData_Y, exogeneous_U, mockSys] = behavARX_test.getKnownMultiInputData();

            % train the arx model
            [ sys, theta, conditionNum ] = behavARX( trainData, modelOrder );

            [~,NRMSE,~] = compare(iddata(outputData_Y, exogeneous_U), sys);
            if showFigures == true
                figure;
                compare(iddata(outputData_Y, exogeneous_U), sys);
                title('Model vs Data');
            end
            NRMSE
            sys
%             if exist('mockSys', 'var')
%                 Adiff = mockSys.a - sys.a;
%                 Bdiff = mockSys.b - sys.b;
%                 disp('actual vs learned coeffs (should be near 0):');
%                 disp('A-A`=')
%                 disp(Adiff)
%                 disp('B-B`=')
%                 disp(Bdiff)
%             end
        end
        
        function [] = testTrainOnKnownModel()
            % test 2 evaluation of the behavARX by training on a known model.
            showFigures = false;  % set to true if you want to see plots

            modelOrder = 3;
            exogeneous_U = mockInputData(5000, 'random');
            
            A = cell(1,1);
            A{1,1} = [1 0 0 0];  % out1 to out1 t-0 t-1 t-2 t-3
            
            B = cell(1, 1);
            B{1,1} = [0 0 -.5 .5]; %in1 to out1 t-1 t-2 t-3
            
            mockSys = idpoly(A, B);  % mock arx model
            outputData_Y = sim(mockSys, exogeneous_U);

            % split the data
%              percentTrain = .80;
%             [trainData, testData, trainTestRatio] = randomSelectionSplit(outputData_Y, exogeneous_U, percentTrain);
% 
%             if showFigures == true
%                 plot(trainData);
%                 title('Training Data');
%                 figure;
%                 plot(testData);
%                 title('Validation Data');
%             end
            % or don't split data:
            trainData = iddata(outputData_Y, exogeneous_U);


            % train the arx model
            [ sys, theta, conditionNum ] = behavARX( trainData, modelOrder );

            [~,NRMSE,~] = compare(iddata(outputData_Y, exogeneous_U), sys);
            if showFigures == true
                figure;
                compare(iddata(outputData_Y, exogeneous_U), sys);
                title('Model vs Data');
            end
            NRMSE
            if exist('mockSys', 'var')
                Adiff = mockSys.a - sys.a;
                Bdiff = mockSys.b - sys.b;
                disp('actual vs learned coeffs (should be near 0):');
                disp('A-A`=')
                disp(Adiff)
                disp('B-B`=')
                disp(Bdiff)
            end
        end
        
        function [modelOrder, trainData, outputData_Y, exogeneous_U, mockSys] = getKnownMultiInputData()
            modelOrder = 3;
            exogeneous_U = [mockInputData(100, 'random'), mockInputData(100, 'random')];

            A = cell(1,1);
            A{1,1} = [1 .2 -.3 .4];  % out1 to out1 t-0 t-1 t-2 t-3

            B = cell(1, 1);
            B{1,1} = [-.5 .6 -.7 .8]; %in1 to out1 t-1 t-2 t-3
            B{1,2} = [.9 -.11 .12 .13];  %in2 to out1 

            mockSys = idpoly(A, B);  % mock arx model
            outputData_Y = sim(mockSys, exogeneous_U);

            trainData = iddata(outputData_Y, exogeneous_U);
        end  % /function getKnownMultiInputData
    end  %/static methods
end
