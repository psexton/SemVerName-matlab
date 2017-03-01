classdef SemanticVersionTest < TestCase
    %SEMANTICVERSIONTEST xUnit tests for the SemanticVersion class
    
    methods (Access = private)
        function assignValueToProperty(~, value, propertyName)
            version = SemanticVersion();
            version.(propertyName) = value;
        end
    end
    
    methods
        function obj = SemanticVersionTest(name)
            obj = obj@TestCase(name);
        end
        
        function testArraysOfSemanticVersionsCanBeSorted(~)
            version1 = SemanticVersion('5.3.1');
            version2 = SemanticVersion('2.3.5');
            version3 = SemanticVersion('1.9.10');
            version4 = SemanticVersion('3.10.5');
            version2p1 = SemanticVersion('2.3.5-beta1');
            version2p2 = SemanticVersion('2.3.5-beta2');
            
            expectedOrder = [version3; version2p1; version2p2; version2; version4; version1];
            actualOrder = sort([version1; version2; version3; version4; version2p2; version2p1]);
            
            assertEqual(expectedOrder, actualOrder);
        end
        
        function testSortReturnsTwoParameters(~) % See bug #1300
            version1 = SemanticVersion('5.3.1');
            version2 = SemanticVersion('2.3.5');
            version3 = SemanticVersion('1.9.10');
            orig = [version1 version2 version3];
            expectedOrder = [version3 version2 version1];
            expectedIndices = [3 2 1];
            [actualOrder, actualIndices] = sort(orig);
            
            assertEqual(expectedOrder, actualOrder);
            assertEqual(expectedIndices, actualIndices);
        end

        function testSortPrerelease(~)
            version1 = SemanticVersion('1.0.0-alpha');
            version2 = SemanticVersion('1.0.0-alpha.1');
            version3 = SemanticVersion('1.0.0-alpha.beta');
            version4 = SemanticVersion('1.0.0-alpha.beta.2');
            version5 = SemanticVersion('1.0.0-alpha.beta.11');
            version6 = SemanticVersion('1.0.0-rc.1');
            version7 = SemanticVersion('1.0.0');

            expectedOrder = [version1; version2; version3; version4; version5; version6; version7];
            actualOrder = sort([version6; version4; version1; version3; version2; version7; version5]);

            assertEqual(expectedOrder, actualOrder);
        end
        
        function testCanBeConvertedToCharacterArray(~)
            expectedVersion = '1.2.3';
            
            version = SemanticVersion();
            version.string = expectedVersion;
            
            assertEqual(expectedVersion, char(version));
        end
        
        function testCanBeConvertedToCharacterArrayWithPrerelease(~)
            expectedVersion = '1.2.3-pre7';
            
            version = SemanticVersion();
            version.string = expectedVersion;
            
            assertEqual(expectedVersion, char(version));
        end
        
        function testCanBeInstantiatedUsingStringArgument(~)
            expectedMajor = 1;
            expectedMinor = 2;
            expectedPatch = 3;
            expectedPrerelease = 'beta1';
            
            version = SemanticVersion('1.2.3-beta1');
            
            assertEqual(expectedMajor, version.major);
            assertEqual(expectedMinor, version.minor);
            assertEqual(expectedPatch, version.patch);
            assertEqual(expectedPrerelease, version.prerelease);
        end
        
        function testCanDetermineEqualityRelation(~) % See bug #1301
            version1a = SemanticVersion('1.0.0');
            version1b = SemanticVersion('1.0.0');
            version2 = SemanticVersion('2.0.0');
            
            assertTrue(version1a == version1b);
            assertFalse(version1a == version2);
        end
        
        function testCanDetermineGreaterThanRelation(~)
            version1 = SemanticVersion('1.0.0');
            version2 = SemanticVersion('1.2.3');
            version2p1 = SemanticVersion('1.2.3-p1');
            version2p2 = SemanticVersion('1.2.3-p2');
            
            assertFalse(version1 > version1);
            assertFalse(version1 > version2);
            assertTrue(version2 > version1);
            
            assertFalse(version2p1 > version2p1);
            assertFalse(version2p1 > version2);
            assertTrue(version2p1 > version1);
            assertTrue(version2p2 > version2p1);
            assertFalse(version2p1 > version2);
        end
        
        function testCanDetermineGreaterThanOrEqualRelation(~)
            version1 = SemanticVersion('1.0.0');
            version2 = SemanticVersion('1.2.3');
            version2p1 = SemanticVersion('1.2.3-p1');
            
            assertTrue(version1 >= version1);
            assertFalse(version1 >= version2);
            assertTrue(version2 >= version1);
            
            assertTrue(version2p1 >= version2p1);
            assertFalse(version2p1 >= version2);
            assertTrue(version2p1 >= version1);
        end
        
        function testCanDetermineLessThanRelation(~)
            version1 = SemanticVersion('1.0.0');
            version2 = SemanticVersion('1.2.3');
            version2p1 = SemanticVersion('1.2.3-p1');
            version2p2 = SemanticVersion('1.2.3-p2');
            
            assertFalse(version1 < version1);
            assertTrue(version1 < version2);
            assertFalse(version2 < version1);
            
            assertFalse(version2p1 < version2p1);
            assertTrue(version2p1 < version2);
            assertFalse(version2p1 < version1);
            assertTrue(version2p1 < version2p2);
            assertFalse(version2 < version2p1);
        end
        
        function testCanDetermineLessThanOrEqualRelation(~)
            version1 = SemanticVersion('10.20.30');
            version2 = SemanticVersion('1.2.3');
            version2p1 = SemanticVersion('1.2.3-p1');
            
            assertTrue(version1 <= version1);
            assertTrue(version2 <= version1);
            assertFalse(version1 <= version2);
            
            assertTrue(version2p1 <= version2p1);
            assertTrue(version2p1 <= version1);
            assertFalse(version1 <= version2p1);
        end
        
        function testCanReturnVersionNumberAsCharacterArray(~)
            expectedVersion = '1.2.3';
            
            version = SemanticVersion();
            version.string = expectedVersion;
            
            assertEqual(expectedVersion, version.string);
        end
        
        function testHasMajorVersionPart(~)
            expectedMajor = 1;
            
            version = SemanticVersion();
            version.major = expectedMajor;
            
            assertEqual(expectedMajor, version.major);
        end
        
        function testHasMinorVersionPart(~)
            expectedMinor = 2;
            
            version = SemanticVersion();
            version.minor = expectedMinor;
            
            assertEqual(expectedMinor, version.minor);
        end
        
        function testHasPatchVersionPart(~)
            expectedPatch = 1;
            
            version = SemanticVersion();
            version.patch = expectedPatch;
            
            assertEqual(expectedPatch, version.patch);
        end
        
        function testHasPrereleaseVersionPart(~)
            expectedPrerelease = 'beta1';
            
            version = SemanticVersion();
            version.prerelease = expectedPrerelease;
            
            assertEqual(expectedPrerelease, version.prerelease);
        end
        
        function testMajorVersionPartDefaultsToZero(~)
            expectedMajor = 0;
            
            version = SemanticVersion();
            
            assertEqual(expectedMajor, version.major);
        end
        
        function testMinorVersionPartDefaultsToZero(~)
            expectedMinor = 0;
            
            version = SemanticVersion();
            
            assertEqual(expectedMinor, version.minor);
        end
        
        function testPatchVersionPartDefaultsToZero(~)
            expectedPatch = 0;
            
            version = SemanticVersion();
            
            assertEqual(expectedPatch, version.patch);
        end
        
        function testPrereleaseVersionPartDefaultsToEmpty(~)
            expectedPrerelease = '';
            
            version = SemanticVersion();
            
            assertEqual(expectedPrerelease, version.prerelease);
        end
        
        function testShouldBeAbleToSetVersionNumberFromString(~)
            expectedMajor = 1;
            expectedMinor = 2;
            expectedPatch = 3;
            expectedPrerelease = '';
            
            version = SemanticVersion();
            version.string = '1.2.3';
            
            assertEqual(expectedMajor, version.major);
            assertEqual(expectedMinor, version.minor);
            assertEqual(expectedPatch, version.patch);
            assertEqual(expectedPrerelease, version.prerelease);
        end
        
        function testShouldBeAbleToSetPrereleaseFromString(~)
            expectedMajor = 1;
            expectedMinor = 2;
            expectedPatch = 3;
            expectedPrerelease = 'beta2';
            
            version = SemanticVersion();
            version.string = '1.2.3-beta2';
            
            assertEqual(expectedMajor, version.major);
            assertEqual(expectedMinor, version.minor);
            assertEqual(expectedPatch, version.patch);
            assertEqual(expectedPrerelease, version.prerelease);
        end
        
        function testStoresVersionPartsAsDoubles(~)
            expectedMajor = 1;
            expectedMinor = 2;
            expectedPatch = 3;
            
            version = SemanticVersion();
            version.major = '1';
            version.minor = '2';
            version.patch = '3';
            
            assertEqual(expectedMajor, version.major);
            assertEqual(expectedMinor, version.minor);
            assertEqual(expectedPatch, version.patch);
        end
        
        function testStoresPrereleaseAsString(~)
            version = SemanticVersion();
            version.prerelease = '1';
            
            assertTrue(ischar(version.prerelease));
        end
        
        function testStringPropertyRequiresCharacterArray(obj)
            expectedException = 'SemanticVersion:invalidValue';
            
            functionCall = @() obj.assignValueToProperty(1, 'string');
            assertExceptionThrown(functionCall, expectedException);
        end
        
        function testPrereleasePropertyRequiresCharacterArray(obj)
            expectedException = 'SemanticVersion:invalidValue';
            
            functionCall = @() obj.assignValueToProperty(1, 'prerelease');
            assertExceptionThrown(functionCall, expectedException);
        end
        
        function testVersionPartsShouldBeNumericOrStringsContainingDigits(obj)
            expectedException = 'SemanticVersion:invalidVersionPartValue';
            
            functionCall = @() obj.assignValueToProperty('foo', 'major');
            assertExceptionThrown(functionCall, expectedException);
            
            functionCall = @() obj.assignValueToProperty(struct('foo', 'bar'), 'minor');
            assertExceptionThrown(functionCall, expectedException);
            
            functionCall = @() obj.assignValueToProperty(true, 'patch');
            assertExceptionThrown(functionCall, expectedException);
        end
        
        function testVersionPartsShouldRejectNonIntegerValues(obj)
            expectedException = 'SemanticVersion:invalidVersionPartValue';
            
            functionCall = @() obj.assignValueToProperty('1.4', 'major');
            assertExceptionThrown(functionCall, expectedException);
            
            functionCall = @() obj.assignValueToProperty(1.5, 'major');
            assertExceptionThrown(functionCall, expectedException);
        end
        
        function testVersionPartsShouldRejectNegativeValues(obj)
            expectedException = 'SemanticVersion:invalidVersionPartValue';
            
            functionCall = @() obj.assignValueToProperty('-2', 'major');
            assertExceptionThrown(functionCall, expectedException);
            
            functionCall = @() obj.assignValueToProperty(-1, 'major');
            assertExceptionThrown(functionCall, expectedException);
        end

        function testPrereleasePartShouldAcceptDotSeparatedIdentifiers(obj)
            prereleaseString = 'rc.1.beta';

            try
                obj.assignValueToProperty(prereleaseString, 'prerelease');
            catch exception %#ok<NASGU>
            end

            assertEqual(exist('exception', 'var'), 0, ...
                sprintf('Prerelease string ''%s'' was rejected', prereleaseString));
        end

        function testPrereleasePartShouldAcceptEmptyString(obj)
            prereleaseString = '';

            try
                obj.assignValueToProperty(prereleaseString, 'prerelease');
            catch exception %#ok<NASGU>
            end

            assertEqual(exist('exception', 'var'), 0, ...
                sprintf('Prerelease string ''%s'' was rejected', prereleaseString));
        end

        function testPrereleasePartShouldAcceptLeadingZeroesOnAlphaIdentifier(obj)
            prereleaseString = '0123alpha456';

            try
                obj.assignValueToProperty(prereleaseString, 'prerelease');
            catch exception %#ok<NASGU>
            end

            assertEqual(exist('exception', 'var'), 0, ...
                sprintf('Prerelease string ''%s'' was rejected', prereleaseString));
        end

        function testPrereleasePartShouldAcceptSingleZero(obj)
            prereleaseString = '0';

            try
                obj.assignValueToProperty(prereleaseString, 'prerelease');
            catch exception %#ok<NASGU>
            end

            assertEqual(exist('exception', 'var'), 0, ...
                sprintf('Prerelease string ''%s'' was rejected', prereleaseString));
        end

        function testPrereleasePartShouldRejectEmptyIdentifiers(obj)
            prereleaseString = '1..3';
            expectedException = 'SemanticVersion:invalidVersionPartValue';

            functionCall = @() obj.assignValueToProperty(prereleaseString, 'prerelease');
            assertExceptionThrown(functionCall, expectedException, ...
                sprintf('Prerelease string ''%s'' was accepted', prereleaseString));
        end

        function testPrereleasePartShouldRejectLeadingZeroesOnNumericIdentifier(obj)
            prereleaseString = '01';
            expectedException = 'SemanticVersion:invalidVersionPartValue';

            functionCall = @() obj.assignValueToProperty(prereleaseString, 'prerelease');
            assertExceptionThrown(functionCall, expectedException, ...
                sprintf('Prerelease string ''%s'' was accepted', prereleaseString));
        end
        
        function testPrereleasePartShouldRejectNonAlphanumericNonDash(obj)
            prereleaseString = '1_2';
            expectedException = 'SemanticVersion:invalidVersionPartValue';

            functionCall = @() obj.assignValueToProperty(prereleaseString, 'prerelease');
            assertExceptionThrown(functionCall, expectedException, ...
                sprintf('Prerelease string ''%s'' was accepted', prereleaseString));
        end
        
        function testCtrShouldRejectNonIntegerValues(~)
            expectedException = 'SemanticVersion:invalidValue';
            
            functionCall = @() SemanticVersion('a.b.c');
            assertExceptionThrown(functionCall, expectedException);
        end
        
        function testCanDetermineCompatiblyGreaterThanRelation(~)
            version10 = SemanticVersion('10.20.30');
            version1 = SemanticVersion('1.2.3');
            version1p1 = SemanticVersion('1.2.3-p1');
            
            version04 = SemanticVersion('0.4.0');
            version041 = SemanticVersion('0.4.1');
            
            % for major version 0, always return false
            assertFalse(cgt(version041, version04));
            assertFalse(cgt(version1, version04));
            
            % for major version 1, true if rhs is > and has same major
            assertTrue(cgt(version1, version1p1));
            assertFalse(cgt(version10, version1));
        end
        
        function testEqualIsNotGreaterThan(~)
            version1 = SemanticVersion('1.0.0');
            assertFalse(gt(version1, version1));
        end
        
        function testEqualIsCompatiblyGreaterThan(~)
            version1 = SemanticVersion('1.0.0');
            assertTrue(cgt(version1, version1));
        end
    end
end
