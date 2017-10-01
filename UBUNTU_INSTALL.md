# Install Forth / f on an Ubuntu System

## Before Installing

0. Uninstall the version of GForth that Ubuntu comes with: `sudo apt-get remove gforth`. It is too old to support .
1. Download and unpack [GForth 0.7.3](http://ftp.gnu.org/gnu/gforth/gforth-0.7.3.tar.gz). Do _not_ use `apt-get` for this! It is extremely outdated.
2. `cd` into the GForth source directory and run `touch gforth.elc` (?)
3. Run the GForth installation commands as usual:

```
./configure
make
make check
(sudo) make install
```

Your system is now ready for installation. See (README.md)[README.md] next.
