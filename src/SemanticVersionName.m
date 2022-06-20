classdef SemanticVersionName < handle
    %SEMANTICVERSIONNAME Represents a semantic version name
    
    properties (Access = public)
        % A semantic version consists of three version parts
        name = 'noname';
        semver = SemanticVersion();
    end
    
    properties (Dependent, Access = public)
        string
    end
    
    methods (Access = private)
        function value = ensureValidSemVerPartValue(~, value)
            if(isa(value, 'SemanticVersion'))
                % do nothing, already a semver instance
            elseif(ischar(value))
                value = SemanticVersion(value);
            else
                error('SemanticVersionName:invalidSemVerPartValue', ...
                    'SemVer should be specified as a string');
            end
        end
        
        function value = ensureValidNamePartValue(~, value)
            assert(ischar(value),  'SemanticVersionName:invalidNamePartValue', ...
                'Name should be specified as a string');
            
            % check for non-alphanumeric non-hyphen non-underscore characters
            expression = '[^\w-]';
            matchstart = regexp(value, expression, 'start', 'once');
            assert(isempty(matchstart), 'SemanticVersionName:invalidNamePartValue', ...
                'Name string can only contain alphanumerics, hyphens and underscores');
        end
        
        function tf = string_lt(~, str1, str2)
            if(strcmp(str1, str2))
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

    methods (Static)
            function tf = isValid(value)
                % The logic for validating a pattern is baked so tightly into the setters,
                % just try to instantiate it and catch exceptions
                try
                    temp = SemanticVersionName(value);
                    tf = true;
                catch ME
                    if(startsWith(ME.identifier, "SemanticVersionName:"))
                        tf = false;
                    else
                        rethrow(ME)
                    end
                end
            end
        end
    
    methods
        function obj = SemanticVersionName(varargin)
            if nargin > 1
                % with two arguments, it might be two strings, or a string
                % + a semver obj
                if(isa(varargin{2}, 'SemanticVersion'))
                    semVerIn = varargin{2};
                    obj.string = [varargin{1} '-' semVerIn.string];
                else
                    obj.string = [varargin{1} '-' varargin{2}];
                end
            elseif nargin > 0
                % with one argument, it might be a string or a semvername
                % obj
                if(isa(varargin{1}, 'SemanticVersionName'))
                    semVerNameIn = varargin{1};
                    obj.string = semVerNameIn.string;
                else
                    obj.string = varargin{1};
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
        
        function value = eq(obj, otherObj)
            value = isequal(obj, otherObj);
        end
        
        function value = get.string(obj)
            value = sprintf('%s-%s', obj.name, obj.semver.string);
        end
        
        function value = ge(obj, otherObj)
            value = isequal(obj, otherObj) || gt(obj, otherObj);
        end
        
        function value = gt(obj, otherObj)
            value = ~le(obj, otherObj);
        end
        
        function value = le(obj, otherObj)
            value = isequal(obj, otherObj) || lt(obj, otherObj);
        end
        
        function value = lt(obj, otherObj)
            % obj < otherObj if any of the following are true 
            % (name-semver abbreviations used):
            %   1) name < other's name
            %   2) namess are equal, and semver < other's semver
            value = obj.string_lt(obj.name, otherObj.name) || (strcmp(obj.name, otherObj.name) && obj.semver < otherObj.semver);
        end
        
        function value = cgt(obj, otherObj)
            % names must match, and semvers must have a cgt relation
            value = (strcmp(obj.name, otherObj.name) && cgt(obj.semver, otherObj.semver));
        end
        
        function set.name(obj, value)
            value = convertStringsToChars(value);
            obj.name = obj.ensureValidNamePartValue(value);
        end
        
        function set.semver(obj, value)
            value = convertStringsToChars(value);
            obj.semver = obj.ensureValidSemVerPartValue(value);
        end
        
        function set.string(obj, value)
            value = convertStringsToChars(value);
            assert(ischar(value), 'SemanticVersionName:invalidValue', ...
                'VersionNames should be set using strings');
            
            expression = '^([\w-]+)-((\d+\.\d+\.\d+)(-[^+]+)?(\+.+)?)$';
            versionnamePartValues = regexp(value, expression, 'tokens', 'once');
            nVersionnamePartValues = numel(versionnamePartValues);
            
            assert(nVersionnamePartValues == 2, 'SemanticVersionName:invalidValue', ...
                'VersionNames should consist of a name and a SemanticVersion');

            obj.name = versionnamePartValues{1};
            obj.semver = versionnamePartValues{2};
            
            % if something miscellaneously invalid was specified, then
            % value will not match our reconstructed string value
            assert(strcmp(value, obj.string), 'SemanticVersionName:invalidValue', ...
                'Hyphen must separate name and semver');
        end
        
        function [sortedObj, idx] = sort(obj)
            % We can't use sortrows with a mix of string and class
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
