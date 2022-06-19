classdef MatlabStringTest < TestCase
    %MATLABSTRINGTEST xUnit tests for passing matlab strings into the SemanticVersion and SemanticVersionName classes
    
    methods
        function obj = MatlabStringTest(name)
            obj = obj@TestCase(name);
        end
        
        function testSemVerCtrCanAcceptString(~)
            expectedVersion = "1.2.3";

            version = SemanticVersion(expectedVersion);
            assertEqual(char(expectedVersion), version.string);
        end

        function testSemVerStringPropCanAcceptString(~)
            expectedVersion = "1.2.3";

            version = SemanticVersion();
            version.string = expectedVersion;

            assertEqual(char(expectedVersion), char(version));
        end

        function testMajorCanAcceptString(~)
            expectedMajor = "12";

            version = SemanticVersion();
            version.major = expectedMajor;

            assertEqual(str2num(expectedMajor), version.major);
        end

        function testMinorCanAcceptString(~)
            expectedMinor = "44";

            version = SemanticVersion();
            version.minor = expectedMinor;

            assertEqual(str2num(expectedMinor), version.minor);
        end

        function testPatchCanAcceptString(~)
            expectedPatch = "906";

            version = SemanticVersion();
            version.patch = expectedPatch;

            assertEqual(str2num(expectedPatch), version.patch);
        end
        
        function testPrereleaseCanAcceptString(~)
            expectedPre = "alpha1";

            version = SemanticVersion();
            version.prerelease = expectedPre;

            assertEqual(char(expectedPre), version.prerelease);
        end

        function testBuildMetadataCanAcceptString(~)
            expectedBuild = "build3d4c2a";

            version = SemanticVersion();
            version.build_metadata = expectedBuild;

            assertEqual(char(expectedBuild), version.build_metadata);
        end

        function testSemVerNameCtrCanAcceptString(~)
            expectedVersionName = "georgia-1.2.3-beta2";

            versionName = SemanticVersionName(expectedVersionName);
            assertEqual(char(expectedVersionName), versionName.string);
        end

        function testSemVerNameStringPropCanAcceptString(~)
            expectedVersionName = "georgia-1.2.3-beta2";

            versionName = SemanticVersionName();
            versionName.string = expectedVersionName;

            assertEqual(char(expectedVersionName), char(versionName));
        end

        function testNameCanAcceptString(~)
            expectedName = "alfred";

            versionName = SemanticVersionName();
            versionName.name = expectedName;

            assertEqual(char(expectedName), versionName.name);
        end

        function testVersionCanAcceptString(~)
            expectedVersion = "45.67.89";

            versionName = SemanticVersionName();
            versionName.semver = expectedVersion;

            assertEqual(SemanticVersion(expectedVersion), versionName.semver);
        end
    end
end
