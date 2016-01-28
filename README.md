SuaNC
-----

SuaNC is a project to experiment with a Swift support for NCurses, while using
the Sua library as a base.

-------------------

**News - January 28, 2016.**

This project has come to a stop for now. I found out that it was crashing a lot
when outputting anything and resizing the terminal window at the same time.
Resizing it caused it to refresh, which caused it to output more and the
interaction with NCurses from Swift ended up badly then, with crashes. For
instance, when I just commented out the
[line calling "addstr",](Sources/ncurses.swift#L960) the crashes
seemed to stop occurring. Even calling "addch(65)" in its place seemed to be
enough to cause it to crash when resizing the terminal window at the same time.

Plus, debugging crashes while the terminal itself would get messed up after
a crash was difficult, to say the least. Add to it that the terminal output
would get restricted by the application we were developing, which would hide the
easy output that we could use for debugging purposes. I was able to go a long
way with just some debugging output on the application itself, which I got used
to from JavaScript a while back. But for other people, this would not be nearly
enough.

NCurses has restricted colors by default. I was OK with it because I could set
up the colors I like better on my terminal. But even then I didn't get all the
colors that I had wanted when I experimented with them. For example, bold black
was not coming out right -- it was more grayish. The NCurses colors seem to fall
back to their default settings.

Still, I had some fun. I liked it that I could use Unicode to draw up the
borders and to use accented characters and even some Unicode symbols were fun
to try out.

The monospace fonts allowed me to quickly iterate on the layout code. And I even
got a custom "timer interval" to interact with the NCurses general loop with the
timeout and getch functions.

A note on Swift itself is that for a moment, with the crashes, I was doubting
how solid Swift could be. I have probably found out why many Swift developers
may hate for-loops with indices that could cause a crash if the end index is
lower than the start index. The thing is that as the code base grows bigger,
such doubts tend to get compounded. For many Swift users though, such issues are
mitigated if they use the Xcode IDE, I think, because they get crash back-traces
that can help them to figure out the issues sooner. For me on Linux, it's a
different story. :-)

From here on out, I intend to give SDL2 a spin.

-------------------

As a way not to slow down development, rather than to depend on Sua as an
external, static library, we have added the Sua's files directly to the Sources
directory. In effect "inlining" them.

The current snapshot from Sua is this one:

    commit 108f26ede4dd5d020e4896aed48f8c54063b3137
    Author: Joao Pedrosa [...]
    Date:   Fri Jan 22 23:35:52 2016 -0300

Another dependency is the CNC library from here:
https://github.com/jpedrosa/cnc_module

It is a straightforward NCurses header mapping library that links to the Unicode
version of NCurses. It includes this dependency:

    sudo apt-get install libncursesw5-dev

-------------------

For a reference on working with NCurses from Swift, you can check the
following article:

* http://dev.iachieved.it/iachievedit/ncurses-with-swift-on-linux/

License
-------

See the [LICENSE](LICENSE.txt) file.
