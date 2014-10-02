classdef SemanticVersionNameCtrTest < TestCase
    %SEMANTICVERSIONNAMECTRTEST xUnit tests for the SemanticVersionName class's constructor
    
    properties(Access=private)
       nameString;
       semVerString;
       semVerNameString;
    end
    
    methods
        function obj = SemanticVersionNameCtrTest(name)
            obj = obj@TestCase(name);
            obj.nameString = 'apple';
            obj.semVerString = '1.2.3-beta2';
            obj.semVerNameString = [obj.nameString '-' obj.semVerString];
        end
        
        % Test that we can pass in a hyphenated string parameter
        function testStringParameter(this)
            version = SemanticVersionName(this.semVerNameString);
            assertEqual(this.semVerNameString, version.string);
        end
        
        % Test that we can pass in a semvername object parameter
        function testSemVerNameParameter(this)
            semvername1 = SemanticVersionName(this.semVerNameString);
            semvername2 = SemanticVersionName(semvername1);
            assertEqual(this.semVerNameString, semvername2.string);
        end
        
        % Test that we can pass in a string and a semver object as parameters
        function testStringAndSemVerParameters(this)
            semVerObj = SemanticVersion(this.semVerString);
            semvername = SemanticVersionName(this.nameString, semVerObj);
            assertEqual(this.semVerNameString, semvername.string);
        end
        
        % Test that we can pass in two strings as parameters
        function testTwoStringParameters(this)
            semvername = SemanticVersionName(this.nameString, this.semVerString);
            assertEqual(this.semVerNameString, semvername.string);
        end
    end
end