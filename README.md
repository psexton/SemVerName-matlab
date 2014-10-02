SemVerName-matlab
=================

Overview
--------

Semantic Versioning (semver) and Semantically Versioned Names (semvername), for matlab.

Notes
-----

Our implementation of Semantic Versioning almost precisely matches that of the Semantic Versioning Specification v1.0.0, with the following change:

In rule 2, major, minor, and patch versions must be non-negative integers.

The sematic version specification is available at <http://www.semver.org>. A copy of the 1.0.0 spec is mirrored here as "doc/semantic_versioning_spec_1.0.0.html".

So while everything that is compatible with our implementation is valid for the 1.0.0 spec, not everything that is valid 1.0.0 SemVer is compatible with our implementation.

Installation
------------

Run the `onLoad` script to load this package onto the MATLAB path. Run the `onUnload` script to remove it from the path.

Dependencies
------------

Semantic Versioning requires MATLAB 2010a or later.

License
-------

BSD 2-Clause
