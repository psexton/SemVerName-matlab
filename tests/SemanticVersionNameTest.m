classdef SemanticVersionNameTest < TestCase
    %SEMANTICVERSIONNAMETEST xUnit tests for the SemanticVersionName class
    
    methods (Access = private)
        function assignValueToProperty(~, value, propertyName)
            versionName = SemanticVersionName();
            versionName.(propertyName) = value;
        end
    end
    
    methods
        function obj = SemanticVersionNameTest(name)
            obj = obj@TestCase(name);
        end
        
        function testArraysOfSemanticVersionNamesCanBeSorted(~)
            versionName1 = SemanticVersionName('apple-4.5.6');
            versionName2 = SemanticVersionName('banana-1.2.3');
            versionName3 = SemanticVersionName('banana-7.8.9');
            versionName4 = SemanticVersionName('apple_jack-0.1.2-pre1');
            
            expectedOrder = [versionName1; versionName4; versionName2; versionName3];
            actualOrder = sort([versionName4; versionName1; versionName3; versionName2]);
            
            assertEqual(expectedOrder, actualOrder);
        end
        
        function testSortReturnsTwoParameters(~) % See bug #1300
            versionName1 = SemanticVersionName('apple-4.5.6');
            versionName2 = SemanticVersionName('banana-1.2.3');
            versionName3 = SemanticVersionName('banana-7.8.9');
            orig = [versionName3 versionName1 versionName2];
            expectedOrder = [versionName1 versionName2 versionName3];
            expectedIndices = [2 3 1];
            [actualOrder, actualIndices] = sort(orig);
            
            assertEqual(expectedOrder, actualOrder);
            assertEqual(expectedIndices, actualIndices);
        end
        
        function testCanDetermineEqualityRelation(~) % See bug #1301
            apple1a = SemanticVersionName('apple-1.0.0');
            apple1b = SemanticVersionName('apple-1.0.0');
            apple2 = SemanticVersionName('apple-2.0.0');
            zx80 = SemanticVersionName('zx80-1.0.0');
            
            assertTrue(apple1a == apple1b);
            assertFalse(apple1a == apple2);
            assertFalse(apple1a == zx80);
        end
        
        function testCanDetermineGreaterThanRelation(~)
            versionName1 = SemanticVersionName('apple-4.5.6');
            versionName2 = SemanticVersionName('banana-1.2.3');
            versionName3 = SemanticVersionName('banana-7.8.9');
            
            assertFalse(versionName1 > versionName1);
            assertFalse(versionName1 > versionName2);
            assertFalse(versionName2 > versionName3);
            assertTrue(versionName2 > versionName1);
        end
        
        function testCanDetermineGreaterThanOrEqualRelation(~)
            versionName1 = SemanticVersionName('apple-4.5.6');
            versionName2 = SemanticVersionName('banana-1.2.3');
            
            assertTrue(versionName1 >= versionName1);
            assertFalse(versionName1 >= versionName2);
            assertTrue(versionName2 >= versionName1);
        end
        
        function testCanDetermineLessThanRelation(~)
            versionName1 = SemanticVersionName('apple-4.5.6');
            versionName2 = SemanticVersionName('banana-1.2.3');
            versionName3 = SemanticVersionName('banana-7.8.9');
            
            assertFalse(versionName1 < versionName1);
            assertTrue(versionName1 < versionName2);
            assertTrue(versionName2 < versionName3);
            assertFalse(versionName2 < versionName1);
        end
        
        function testCanDetermineLessThanOrEqualRelation(~)
            versionName1 = SemanticVersionName('apple-4.5.6');
            versionName2 = SemanticVersionName('banana-1.2.3');
            
            assertTrue(versionName1 <= versionName1);
            assertTrue(versionName1 <= versionName2);
            assertFalse(versionName2 <= versionName1);
        end
        
        function testCanBeConvertedToCharacterArray(~)
            expectedVersionName = 'jaw_break-er-5.3.1';
            
            versionName = SemanticVersionName();
            versionName.string = expectedVersionName;
            
            assertEqual(expectedVersionName, char(versionName));
        end
        
        function testCanBeInstantiatedUsingStringArgument(~)
            expectedName = 'wonka-chocolate';
            expectedSemVer = SemanticVersion('3.2.1-pre4');
            
            versionName = SemanticVersionName('wonka-chocolate-3.2.1-pre4');
            
            assertEqual(expectedName, versionName.name);
            assertEqual(expectedSemVer, versionName.semver);
        end

        function testCanBeInstantiatedUsingStringContaingBuildMetadata(~)
            expectedName = 'wonka-chocolate';
            expectedSemVer = SemanticVersion('3.2.1-pre4+build1');

            versionName = SemanticVersionName('wonka-chocolate-3.2.1-pre4+build1');

            assertEqual(expectedName, versionName.name);
            assertEqual(expectedSemVer, versionName.semver);
        end
        
        function testHasNamePart(~)
            expectedName = 'hello_World';
            versionName = SemanticVersionName();
            versionName.name = expectedName;
            assertEqual(expectedName, versionName.name);
        end
        
        function testHasSemVerPart(~)
            expectedSemVer = SemanticVersion('1.0.0');
            versionName = SemanticVersionName();
            versionName.semver = expectedSemVer;
            assertEqual(expectedSemVer, versionName.semver);
        end
        
        function testNamePartDefaultsToNoname(~)
            expectedName = 'noname';
            versionName = SemanticVersionName();
            assertEqual(expectedName, versionName.name);
        end
        
        function testSemVerPartDefaultsToZero(~)
            expectedSemVer = SemanticVersion('0.0.0');
            versionName = SemanticVersionName();
            assertEqual(expectedSemVer, versionName.semver);
        end
        
        function testShouldBeAbleToSetNameFromString(~)
            expectedName = 'refurb-assist';
            versionName = SemanticVersionName();
            versionName.name = expectedName;
            assertEqual(expectedName, versionName.name);
        end
        
        function testShouldBeAbleToSetSemVerFromString(~)
            expectedSemVer = '1.2.3-pre41-2';
            versionName = SemanticVersionName();
            versionName.semver = expectedSemVer;
            assertEqual(expectedSemVer, versionName.semver.string); % can't compare string to semVer obj directly
        end
        
        function testShouldBeAbleToSetSemVerFromSemVer(~)
            expectedSemVer = SemanticVersion('1.2.3-pre41-2');
            versionName = SemanticVersionName();
            versionName.semver = expectedSemVer;
            assertEqual(expectedSemVer, versionName.semver);
        end
        
        function testStringPropertyRequiresCharacterArray(obj)
            expectedException = 'SemanticVersionName:invalidValue';
            functionCall = @() obj.assignValueToProperty(1, 'string');
            assertExceptionThrown(functionCall, expectedException);
        end
        
        function testNamePropertyRequiresCharacterArray(obj)
            expectedException = 'SemanticVersionName:invalidNamePartValue';
            functionCall = @() obj.assignValueToProperty(1, 'name');
            assertExceptionThrown(functionCall, expectedException);
        end
        
        function testSemVerPropertyRequiresCharacterArray(obj)
            expectedException = 'SemanticVersionName:invalidSemVerPartValue';
            functionCall = @() obj.assignValueToProperty(1, 'semver');
            assertExceptionThrown(functionCall, expectedException);
        end
        
        function testNamePartShouldRejectNonAlphanumericNonDash(~)
            expectedException = 'SemanticVersionName:invalidValue';
            functionCall = @() SemanticVersionName('product.subproduct-1.2.3');
            assertExceptionThrown(functionCall, expectedException);
        end
        
        function testSemVerPartShouldRejectInvalidValue(~)
            expectedException = 'SemanticVersionName:invalidValue';
            functionCall = @() SemanticVersionName('product-12.a.3');
            assertExceptionThrown(functionCall, expectedException);
        end
        
        function testCanDetermineCompatiblyGreaterThanRelation(~)
            versionName1 = SemanticVersionName('apple-1.2.3');
            versionName2 = SemanticVersionName('banana-1.2.3');
            versionName3 = SemanticVersionName('banana-1.4.3');
            versionName4 = SemanticVersionName('banana-7.8.9');
            
            % if names are different, return false
            assertFalse(cgt(versionName1, versionName2));
            
            % for major version 1, true if rhs is > and has same major
            assertTrue(cgt(versionName3, versionName2));
            assertFalse(cgt(versionName4, versionName2));
        end
    end
end
