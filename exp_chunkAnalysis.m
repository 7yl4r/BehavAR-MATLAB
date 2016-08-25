function exp_chunkAnalysis(start, step, stop)
    % chunk analysis experiment. Builds N ARX models across chunk sizes
    % between start & stop.
    N = 10;
    for n_chunks = start:step:stop
        fprintf('chunkSize:%d\n', n_chunks);
%         disp(['chunksize: ', n_chunks]);
        PerformAnalysis( N, SplitType.randomChunks, ceil(n_chunks/2), floor(n_chunks/2));
    end
end