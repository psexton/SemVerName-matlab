classdef SemanticVersion < handle
    %SEMANTICVERSION Represents a semantic version number
    
    properties (Access = public)
        % A semantic version consists of three version parts
        major = 0;
        minor = 0;
        patch = 0;
        prerelease = '';
    end
    
    properties (Dependent, Access = public)
        string
    end
    
    methods (Access = private)
        function value = ensureValidVersionPartValue(obj, value)
            isNumericValue = isnumeric(value) && value >= 0 && obj.isInteger(value);
            isValidStringValue = ischar(value) && all(isstrprop(value, 'digit'));
            
            assert(isNumericValue || isValidStringValue, ...
                'SemanticVersion:invalidVersionPartValue', ...
                ['Version part values should be specified as either non-negative ' ...
                'integer valued numeric types or as strings containing only ' ...
                'numeric characters']);
            
            if ischar(value)
                value = str2double(value);
            else
                value = double(value);
            end
        end
        
        function value = ensureValidPrereleaseValue(~, value)
            assert(ischar(value),  'SemanticVersion:invalidValue', ...
                'Prerelease should be specified as a string');

            expression = [
              '(' ... % A prerelease consists of one or more identifiers
                '(^|\.)[\da-zA-Z-]' ... % which start at the beginning of the
                                    ... % string or after a dot and need to
                                    ... % contain at least one valid character.
                '(' ... % This single character can be followed by either
                    '((?<!0)\d+)|' ... % one or more digits if it was not a 0 or
                    ... % any combination of other valid characters if at least
                    ... % one is not a digit
                    '([\da-zA-Z-]*[a-zA-Z-][\da-zA-Z-]*)' ...
                ')?' ... % but this is optional
              ')+$'
            ];
            match = regexp(value, expression, 'match', 'once');

            assert(strcmp(match, value), 'SemanticVersion:invalidVersionPartValue', ...
                ['Prerelease strings consist of one or more (non-empty), ' ...
                 'dot separated identifiers containing alphanumerics and ' ...
                 'hyphens. Numeric identifiers cannot have leading zeros']);
        end
        
        function value = isInteger(~, value)
            value = (value == floor(value));
        end
        
        function tf = prerelease_lt(~, pre1, pre2)
            if(strcmp(pre1, pre2))
                tf = false;
            elseif(~isempty(pre1) && isempty(pre2))
                tf = true; % non-empty prerelease < empty prerelease
            elseif(isempty(pre1) && ~isempty(pre2))
                tf = false;
            else
                % All identifier parts of the prerelease string need to be
                % checked against each other to determine precedence
                tf = false;

                pre1Identifiers = regexp(pre1, '\.', 'split');
                nPre1Identifiers = numel(pre1Identifiers);
                pre2Identifiers = regexp(pre2, '\.', 'split');
                nPre2Identifiers = numel(pre2Identifiers);

                maxIdentifiersToCheck = min(nPre1Identifiers, nPre2Identifiers);
                currentIdentifierIdx = 0;
                while currentIdentifierIdx < maxIdentifiersToCheck && ~tf
                  currentIdentifierIdx = currentIdentifierIdx + 1;
                  pre1Number = str2double(pre1Identifiers{currentIdentifierIdx});
                  pre2Number = str2double(pre2Identifiers{currentIdentifierIdx});
                  pre1IsNumber = ~isnan(pre1Number);
                  pre2IsNumber = ~isnan(pre2Number);

                  if pre1IsNumber && pre2IsNumber
                    % Numeric identifiers should be compared numerically
                    tf = pre1Number < pre2Number;
                  elseif pre1IsNumber && ~pre2IsNumber
                    % Numeric identifiers always have lower precedence than
                    % non-numeric identifiers
                    tf = true;
                  elseif ~pre1IsNumber && ~pre2IsNumber
                    if ~strcmp(pre1Identifiers{currentIdentifierIdx}, pre2Identifiers{currentIdentifierIdx})
                      % For string valued identifiers, lexicographical ordering
                      % is used. If the prerelease identifiers are in sorted
                      % order, the former is the 'lesser'
                      tf = issorted({pre1Identifiers{currentIdentifierIdx}, ...
                                     pre2Identifiers{currentIdentifierIdx}});
                      currentIdentifierIdx = maxIdentifiersToCheck + 1;
                    end
                  end
                end

                % If all prerelease identifiers matched until now the
                % prerelease with the most identifiers has precedence
                if ~tf && currentIdentifierIdx == maxIdentifiersToCheck
                    tf = nPre1Identifiers < nPre2Identifiers;
                end
            end
        end
        
        function tf = prerelease_gt(obj, pre1, pre2)
            tf = obj.prerelease_lt(pre2, pre1);
        end
    end
    
    methods
        function obj = SemanticVersion(versionString)
            if nargin > 0
                % Accept either a string or a SemanticVersion object
                if(isa(versionString, 'SemanticVersion'))
                    obj.string = versionString.string;
                else
                    obj.string = versionString;
                end
            end
        end
        
        function value = char(obj)
            value = obj.string;
        end
        
        function disp(obj)
            nObj = numel(obj);
            for kk = 1:nObj
                disp(obj(kk).string);
            end
        end
        
        function value = get.string(obj)
            if(~isempty(obj.prerelease))
                value = sprintf('%d.%d.%d-%s', obj.major, obj.minor, obj.patch, obj.prerelease);
            else
                value = sprintf('%d.%d.%d', obj.major, obj.minor, obj.patch);
            end
        end
        
        function value = eq(obj, otherObj)
            value = isequal(obj, otherObj);
        end
        
        function value = ne(obj, otherObj)
            value = ~eq(obj, otherObj);
        end
        
        function value = ge(obj, otherObj)
            value = eq(obj, otherObj) || gt(obj, otherObj);
        end
        
        function value = gt(obj, otherObj)
            value = ~le(obj, otherObj);
        end
        
        function value = le(obj, otherObj)
            value = eq(obj, otherObj) || lt(obj, otherObj);
        end
        
        function value = lt(obj, otherObj)
            % obj < otherObj if any of the following are true 
            % (X.Y.Z-pre abbreviations used):
            %   1) X < other's X
            %   2) Xs are equal, and Y < other's Y
            %   3) Xs & Ys are equal, and Z < other's Z
            %   4) Xs, Ys, & Zs are equal, and pre < other's pre
            value = (obj.major < otherObj.major) || ...
                (obj.major == otherObj.major && obj.minor <  otherObj.minor) || ...
                (obj.major == otherObj.major && obj.minor == otherObj.minor && obj.patch < otherObj.patch) || ...
                (obj.major == otherObj.major && obj.minor == otherObj.minor && obj.patch == otherObj.patch && obj.prerelease_lt(obj.prerelease, otherObj.prerelease));
        end
        
        function value = cgt(obj, otherObj)
            % equal is always true
            if(obj == otherObj)
                value = true;
            % if otherObj.major < 1, return false
            elseif(otherObj.major < 1)
                value = false;
            else
                value = ((obj.major == otherObj.major) && (obj > otherObj));
            end
        end
        
        function set.major(obj, value)
            obj.major = obj.ensureValidVersionPartValue(value);
        end
        
        function set.minor(obj, value)
            obj.minor = obj.ensureValidVersionPartValue(value);
        end
        
        function set.patch(obj, value)
            obj.patch = obj.ensureValidVersionPartValue(value);
        end
        
        function set.prerelease(obj, value)
            obj.prerelease = obj.ensureValidPrereleaseValue(value);
        end
        
        function set.string(obj, value)
            assert(ischar(value), 'SemanticVersion:invalidValue', ...
                'Versions should be set using strings');
            
            expression = '(\d+)\.?(\d+)\.?(\d+)(-.+)?';
            versionPartValues = regexp(value, expression, 'tokens', 'once');
            nVersionPartValues = numel(versionPartValues);
            
            % < 3 indicates the digit parts of the regex did not match properly
            assert(nVersionPartValues >= 3, 'SemanticVersion:invalidValue', ...
                'Versions should be set using strings');
            
            obj.major = versionPartValues{1};
            obj.minor = versionPartValues{2};
            obj.patch = versionPartValues{3};                        
            if nVersionPartValues > 3 && ~isempty(versionPartValues{4})
                obj.prerelease = versionPartValues{4};
                % need to strip off initial hyphen from prerelease
                obj.prerelease = obj.prerelease(2:length(obj.prerelease));
            end
            
            % if something miscellaneously invalid was specified, then
            % value will not match our reconstructed string value
            assert(strcmp(value, obj.string), 'SemanticVersion:invalidVersionPartValue', ...
                'Prerelease string must begin with a hyphen');
        end
        
        function [sortedObj, idx] = sort(obj)
            % We can't use sortrows with a mix of numeric and string
            % components. So use an admittedly inefficient bubble sort.
            sortedObj = obj;
            n = length(sortedObj);
            idx = 1:n;
            for i = 1:n-1
                for j = 1:n-1
                    if(sortedObj(j) > sortedObj(j+1))
                        temp = sortedObj(j);
                        sortedObj(j) = sortedObj(j+1);
                        sortedObj(j+1) = temp;
                        tempIdx = idx(j);
                        idx(j) = idx(j+1);
                        idx(j+1) = tempIdx;
                    end
               end
            end
        end
    end
end
