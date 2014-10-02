classdef SemanticVersionCtrTest < TestCase
    %SEMANTICVERSIONCTRTEST xUnit tests for the SemanticVersion class's constructor
    
    properties(Access=private)
        string;
    end
    
    methods
        function obj = SemanticVersionCtrTest(name)
            obj = obj@TestCase(name);
            obj.string = '1.2.3-beta2';
        end
        
        % Test that we can pass in a string parameter
        function testStringParameter(this)
            version = SemanticVersion(this.string);
            assertEqual(this.string, version.string);
        end
        
        % Test that we can pass in a semver object parameter
        function testSemVerParameter(this)
            semver1 = SemanticVersion(this.string);
            semver2 = SemanticVersion(semver1);
            assertEqual(this.string, semver2.string);
        end
    end
end