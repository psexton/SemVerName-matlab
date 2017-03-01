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
        
        function tf = string_lt(~, str1, str2)
            if(strcmp(str1, str2))
                tf = false;
            elseif(~isempty(str1) && isempty(str2))
                tf = true; % non-empty string < empty string
            elseif(isempty(str1) && ~isempty(str2))
                tf = false;
            else
                orig = {str1, str2};
                sorted = sort(orig);
                tf = strcmp(orig{1}, sorted{1}); % if str1 < str2, orig == sorted
            end
        end
        
        function tf = string_gt(obj, str1, str2)
            tf = obj.string_lt(str2, str1);
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
                (obj.major == otherObj.major && obj.minor == otherObj.minor && obj.patch == otherObj.patch && obj.string_lt(obj.prerelease, otherObj.prerelease));
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
