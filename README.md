# f
Forth package manager for [theForthNet](https://theforth.net)


## Installation
Download the zipfile, extract it and use *fget* to install the package itself.
It will be the only package with a cumbersome installation ;)

Step by step:

1. Download the [package](https://theforth.net/package/f/current.zip)
   `wget https://theforth.net/package/f/current.zip`
2. Extract the archive
   `unzip current.zip`
3. Use gforth to install *f* via *fget*.
   `gforth f.4th`
   **Inside Gforth:**
   `fget f x.x.x`
4. Delete the extracted archive
   `rm -Rf f`

From now on you can interface with f just by including `forth-packages/f/x.x.x/f.4th`.

As f is now a plain package, updating it to the latest version is as easy as typing `fget f x.x.x`.


## Usage / Words
### `fall ( -- )`
list all packages

### `fsearch ( <parse-needle> -- )`
list all packages which contain *needle* in their name or description 

### `finfo ( <parse-name> -- )`
display information about a package

**Example** display the readme of the latest version of stringstack:
`finfo stringstack`

### `fget ( <parse-name> <parse-version> -- )`
download a package into *fdirectory*

**Example** download the most recent version of euler303:
`fget euler303 x.x.x`

**Example** download a specific version:
`fget euler303 1.0.0`

Read more about the version numbering scheme in the [package-guidlines](/guidelines)


## Configuration
### fdirectory ( 2variable )
Holds the prefix-path for packages.
Defaults to *default-fdirectory ( -- c-addr n )* which yields `./forth-packages/`.

Normally each project contains its own dependencies in the folder `./forth-packages`.
This makes it very easy to handle and ship a project/package, as everything is contained inside the project folder.
It will also allow easy inclusion of the packages as there is no path-magic involved.

If you feel the need to centralize all packages or use another path layout, modify *fdirectory* like so:
`s" /home/fiz/forth/packages" fdirectory 2!`
