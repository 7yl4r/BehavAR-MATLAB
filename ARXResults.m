classdef ARXResults < handle
    %ARXResults is a data object following the factory pattern
    % to ease creation and meta-analysis of ARX
    % results.
    
    properties
        dataModel
        data
    end
    
    methods
        function self = ARXResults()
            self.dataModel = InputParserDataModel();
%             parser.KeepUnmatched = true;

            self.data = [];
            
            self.dataModel.addParameter('trainTestRatio', nan, ...
                @(x) 0 <= x && 100 <= x);            
            self.dataModel.addParameter('randSeed', nan, @isposint);
            self.dataModel.addParameter('NRMSE', nan, @isnumeric);
            self.dataModel.addParameter('PID', nan, @isnumeric);
            self.dataModel.addParameter('conditionNum', nan, @isnumeric);
            self.dataModel.addParameter('split_type', '', ...
                @(x) isa(x, 'SplitType'));
            self.dataModel.addParameter('n_chunks', nan, @isnumeric);

        end
        
        function rowProps(self, varargin)
            % sets row property 
            self.dataModel.parse(true, varargin{:});
        end
        
        function finishRow(self, resetProps)
            self.dataModel.model
            row = [...
                self.dataModel.model.trainTestRatio,...
                self.dataModel.model.randSeed,...
                self.dataModel.model.NRMSE,...
                self.dataModel.model.PID,...
                self.dataModel.model.conditionNum...
            ];
            self.data = [self.data; row];
            
            if exist('resetProps', 'var') && resetProps==true
                self.dataModel.resetRow()
            end
        end
    end % /methods
    
end

