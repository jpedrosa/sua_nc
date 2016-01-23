SuaNC
-----

SuaNC is a project to experiment with a Swift support for NCurses, while using
the Sua library as a base.

-------------------

As a way not to slow down development, rather than to depend on Sua as an
external, static library, we have added the Sua's files directly to the Sources
directory. In effect "inlining" them.

The current snapshot from Sua is this one:

    commit 108f26ede4dd5d020e4896aed48f8c54063b3137
    Author: Joao Pedrosa [...]
    Date:   Fri Jan 22 23:35:52 2016 -0300

Another dependency is the CNCURSES library from here:
https://github.com/iachievedit/CNCURSES

It is a straightforward NCurses header mapping library.

-------------------

For a reference on working with NCurses from Swift, you can check the
following article:

* http://dev.iachieved.it/iachievedit/ncurses-with-swift-on-linux/

License
-------

See the [LICENSE](LICENSE.txt) file.
