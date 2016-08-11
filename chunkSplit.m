function [ trainData, testData, ratio ] = randomSelectionSplit( outputData_Y, exogeneous_U, n_train_chunks, n_test_chunks, verbose)
% given two data arrays, returns test and training set data objects.
% points are assigned to either test/training in N chunks.
% Under current implementation CHUNK SIZES ARE NOT GUARANTEED.

if ~exist('verbose', 'var')
    verbose = false;
end

n_points = size(outputData_Y, 1);
n_chunks = n_train_chunks + n_test_chunks;
points_per_chunk = floor(n_points/n_chunks);  
% NOTE: last chunk might be a bit bigger
percentTrain = n_train_chunks/(n_chunks);

if verbose
    fprintf('breaking into %d size chunks', points_per_chunk);
end

n_test = 0;
n_train = 0;
trainU = zeros(size(exogeneous_U));
trainY = [length(outputData_Y)];
testU = zeros(size(exogeneous_U));
testY = [length(outputData_Y)];

next_breakpoint = 0;
chunk_is_train = true;
chunk_i = 0;
train_chunk_counter = 0;
for t = 1:length(outputData_Y)
    if next_breakpoint < t  % if time to assign next chunk
        if chunk_i == n_chunks-1  % if last chunk
            next_breakpoint = inf;  % no more breaks
            % last chunk assigned to balance out percent train
            % last chunk is train if train% lower than desired
            chunk_is_train = percentTrain > train_chunk_counter/n_chunks;
            if verbose
                fprintf('last chunk train: %d\n', chunk_is_train);
            end
        else
            chunk_i = chunk_i + 1;
            ran = rand();
            if ran < percentTrain
                chunk_is_train = true;
                train_chunk_counter = train_chunk_counter + 1;
            else
                chunk_is_train = false;
            end
            next_breakpoint = chunk_i*points_per_chunk;
            if verbose
                fprintf('%d -> %d are... %d', t, next_breakpoint);
                fprintf('%d < %d = %d\n', ran, percentTrain, chunk_is_train);
            end
        end
    end
    
    if chunk_is_train
        trainU(t,:) = exogeneous_U(t,:);
        trainY(t) = outputData_Y(t);
        testU(t,:) = nan;
        testY(t) = nan;
        n_train = n_train+1;
    else 
        trainU(t,:) = nan;
        trainY(t) = nan;
        testU(t,:) = exogeneous_U(t,:);
        testY(t) = outputData_Y(t);
        n_test = n_test+1;
    end
end

ratio = round(100*n_train/(n_train+n_test));

if verbose
    fprintf('train:test = %d/%d (%d%% train)\n', ...
     n_train, n_test, ratio);
end

% disp(size(trainY'))
% disp(size(trainU));

trainData = iddata(trainY', trainU);
testData  = iddata(testY',  testU);

end

