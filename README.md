SemVerName-matlab
=================

Overview
--------

[Semantic Versioning (semver)](http://semver.org) and [Semantically Versioned Names (semvername)](http://semvarname.org), for matlab.

Notes
-----

Our implementation of Semantic Versioning almost precisely matches that of the Semantic Versioning Specification v1.0.0, with the following change:

In rule 2, major, minor, and patch versions must be non-negative integers.

The sematic version specification is available at <http://semver.org/spec/v1.0.0.html>. A copy of the 1.0.0 spec is also mirrored here at "doc/semantic_versioning_spec_1.0.0.html".

So while everything that is compatible with our implementation is valid for the 1.0.0 spec, not everything that is valid 1.0.0 SemVer is compatible with our implementation.

Installation
------------

Run the `onLoad` script to load this package onto the MATLAB path. Run the `onUnload` script to remove it from the path.

Dependencies
------------

* MATLAB 2010a or later.
* [matlab-xunit-4.0.0](https://github.com/psexton/matlab-xunit), only if you want to run the unit tests.

License
-------

[BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause)

Contributing
------------

1. Fork it ( https://github.com/psexton/SemVerName-matlab/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request 
