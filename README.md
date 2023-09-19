braw-lib - raw/cooked terminal handling
=======================================
`braw-lib` is a dead-simple terminal handling Racket library for
systems that use `termios`. The `braw` module fascilitates swapping a
tty in and out of raw mode, as well as sending and receiving
characters with just four procedures.

Provided with `braw-lib` is also a small, standalone C library that
simplifies Racket implementation.

Installation
------------
Edit `config.mk` to match your local setup (`braw` is installed into
the `/usr` namespace by default).

Afterwards enter the following command to build and install `braw`:

    make install
    raco pkg install

to uninstall, run:

    make uninstall
    raco pkg remove braw-lib

Using braw
----------
Documentation for the Racket library is installed with the package and
can be found by running `raco docs`. Documentation for the C library
functions can be found in the `braw(3)` man page which is installed
along with the library.
