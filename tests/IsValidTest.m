classdef IsValidTest < TestCase
    %ISVALIDTEST xUnit tests for the isValid methods of the SemanticVersion and SemanticVersionName classes
    
    methods
        function obj = IsValidTest(name)
            obj = obj@TestCase(name);
        end
        
        function testValidSemVer(~)
            validInput = "1.2.3+build";

            result = SemanticVersion.isValid(validInput);
            assertTrue(result);
        end

        function testInvalidSemVer(~)
            invalidInput = "a.c.d";

            result = SemanticVersion.isValid(invalidInput);
            assertFalse(result);
        end

        function testValidSemVerName(~)
            validInput = "corner-62.0.0";

            result = SemanticVersionName.isValid(validInput);
            assertTrue(result);
        end

        function testInvalidSemVerName(~)
            invalidInput = "fuel";

            result = SemanticVersionName.isValid(invalidInput);
            assertFalse(result);
        end
    end
end
