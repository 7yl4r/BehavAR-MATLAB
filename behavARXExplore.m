classdef behavARXExplore
    %behavARXExplore has helper methods for exploring arx modeling results.

    properties(Constant)
        PIDS = '100008 100057 100073 100115 100123 100149 100156 100164 100172 100180 100198 100206 100214 100222 100230 100248 100255 100263';
        PIDS_arry = {'100008', '100057', '100073', '100115', '100123', ...
            '100149', '100156', '100164', '100172', '100180', '100198', ...
            '100206', '100214', '100222', '100230', '100248', '100255', ...
            '100263'
        };
        column = struct( ...
            'NRMSE', 3, ...
            'PID', 4, ...
            'n_chunks', 6 ...
        );
        label = struct( ...
            'NRMSE', 'NRMSE', ...
            'n_chunks', '# Train+Test Chunks'...
        );
    
        limits = struct( ...
            'NRMSE', [-100 100], ...
            'n_chunks', [] ...
            );
    end
    
    methods(Static)
        function scatter(data, xKey, yKey)
            figure;
            scatter(data(:, behavARXExplore.column.(xKey)), ...
                    data(:, behavARXExplore.column.(yKey)));
%             scatter(analysisData(:,3), analysisData(:,6))
            % title();
            xlabel(behavARXExplore.label.(xKey));
            ylabel(behavARXExplore.label.(yKey));
            
%             xlim(behavARXExplore.limits.(xKey));
%             ylim(behavARXExplore.limits.(yKey));
        end
        
        function printBest(data)
            % best of each participant
            pids = unique(data(:,4));
            % run behavARX many times on each participant, record results
            best = zeros(length(pids), size(data,2));
            for i=1:length(pids)
                pid = pids(i);
                p_data = data(data(:,4) == pid,:);
                [val, ind ] = max(p_data(:,3));
                best(i,:) = p_data(ind, :);
            end;
            printmat(best, 'Best Models', ...
                behavARXExplore.PIDS, ...
                '%train randSeed NRMSE PID cond# n_chunks rank' ...
            );


        end
        
        function violinPlot(analysisData)
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
            target_col = behavARXExplore.column.('NRMSE');
            figure;
            [h,L,MX,MED] = violin([...
                analysisData(analysisData(:,behavARXExplore.column.('PID')) == 100008,target_col)...
                analysisData(analysisData(:,behavARXExplore.column.('PID')) == 100057,target_col)...
                analysisData(analysisData(:,behavARXExplore.column.('PID')) == 100073,target_col)...
                analysisData(analysisData(:,behavARXExplore.column.('PID')) == 100115,target_col)...
                analysisData(analysisData(:,behavARXExplore.column.('PID')) == 100123,target_col)...
                analysisData(analysisData(:,behavARXExplore.column.('PID')) == 100149,target_col)...
                analysisData(analysisData(:,behavARXExplore.column.('PID')) == 100156,target_col)...
                analysisData(analysisData(:,behavARXExplore.column.('PID')) == 100164,target_col)...
                analysisData(analysisData(:,behavARXExplore.column.('PID')) == 100172,target_col)...
                analysisData(analysisData(:,behavARXExplore.column.('PID')) == 100180,target_col)...
                analysisData(analysisData(:,behavARXExplore.column.('PID')) == 100198,target_col)...
                analysisData(analysisData(:,behavARXExplore.column.('PID')) == 100206,target_col)...
                analysisData(analysisData(:,behavARXExplore.column.('PID')) == 100214,target_col)...
                analysisData(analysisData(:,behavARXExplore.column.('PID')) == 100222,target_col)...
                analysisData(analysisData(:,behavARXExplore.column.('PID')) == 100230,target_col)...
                analysisData(analysisData(:,behavARXExplore.column.('PID')) == 100248,target_col)...
                analysisData(analysisData(:,behavARXExplore.column.('PID')) == 100255,target_col)...
                analysisData(analysisData(:,behavARXExplore.column.('PID')) == 100263,target_col)...
                ], 'xlabel', behavARXExplore.PIDS_arry);
            % title();
%             ax.XTickLabelRotation=90 % fix crowding (not usable < 2014b)
            xlabel('participant');
            ylabel('NRMSE');
            ylim(behavARXExplore.limits.('NRMSE'));
        end
    end
    
end

