classdef InputParserDataModel < handle
    %InputParserDataModel wraps inputParser to provide a more feature-full
    % parser.Results object.
    %
    % example usage: to parse newly incoming parameters without overwriting
    %   old ones with default values.
    
    properties
        parser
        model
    end
    
    methods
        function self = InputParserDataModel()
            self.parser = inputParser();
            % tempKey used here to avoid "empty struct" issues
            self.model = struct('temp_key', 'tempVal');
        end
        function addParameter(self, key, defaultVal, validator)
            addParameter(self.parser, key, defaultVal, validator);
            %self.model.(key) = defaultVal; (this errors on empty struct)
            self.model.(key) = defaultVal;
            
            % rm tempkey
            if isfield(self.model, 'temp_key')
                self.model = rmfield(self.model, 'temp_key');
            end
            
%             disp('mod:');
%             disp(self.model);
%             disp(fields(self.model));
        end
        function parse(self, doNotOverwriteWithDefault, varargin)
            parse(self.parser, varargin{:});
            self.updateParams()
            if doNotOverwriteWithDefault
                
            end
            
%             self.parser.UsingDefaults()
%             flds = fields(self.parser.Results);
%             for i = 1:length(flds)
%                 fie = flds(i);
%                 if ~isempty(self.parser.UsingDefaults())...
%                         && ~any(strcmp(fie, {self.parser.UsingDefaults()}))...
%                         && ~any(strcmp(fie, {varargin}))
%                     key = char(fie);
%                     val = self.parser.Results.(key);
%                     varargin{size(varargin,1),size(varargin,2)} = key;
%                     varargin{size(varargin,1),size(varargin,2)} = val;
%                 end
%             end
            
        end
        function updateParams(self)
          fields = fieldnames(self.model);
%           fieldnames(self.model)
%           disp(['ttr:' self.model.trainTestRatio]);
          
          for indF = 1:numel(fields)
            tmp = self.parser.Results.(fields{indF});
            if ~isnan(tmp)  % TODO: check for default val, not nan
              self.model.(fields{indF}) = tmp;
            end
          end    
        end
        function resetRow()
            % resets props to defaults (to prevent last row data bleeding
            % over into next row)
            
            % TODO
        end

    end
    
end

