#!/bin/bash
# tar helper, packs everything into a cozy tar for uploading it to theforth.net
# (c) 2016 by Gerald Wodni <gerald.wodni@gmail.com>

PACKAGE=f

# create temorary directory
rm -Rf /tmp/$PACKAGE
mkdir /tmp/$PACKAGE

# copy source
cp *.4th /tmp/$PACKAGE/
cp README* /tmp/$PACKAGE/
cp LICENSE* /tmp/$PACKAGE/

# tar it
tar -czf /tmp/$PACKAGE.tar.gz -C /tmp $PACKAGE
