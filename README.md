# Occupation Employment Statistics database

This repo re-creates the OES database in a Docker image.

The image is built, tagged, and pushed to the registry using the included Makefile. Source files are archived and compressed, then stored using the git large file service.

#### Note for future versions

When a new database is released, download [the source files](https://download.bls.gov/pub/time.series/oe/) using `make download` and review the data structure for changes/errors. The 2014 and 2015 OES dataset structure differed slightly from the 2013 structure; expect structural changes in subsequent datasets as well.

#### Note for local development

Cleaning the source files requires the GNU version of `sed` as well as `dos2unix`, which can be installed on Mac OS X using Homebrew:

    brew install gnu-sed --with-default-names dos2unix
