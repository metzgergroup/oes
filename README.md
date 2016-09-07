# Occupation Employment Statistics database

This repo re-creates the OES database in a Docker image available at registry.gitlab.com/metzger-group/oes<tag>.

The image is built, tagged, and pushed to the registry via a GitLab CI pipeline. In that pipeline, the database is created from the source data with the database files written into a Docker volume, then that volume is used to overwrite the default `PGDATA` directory in a new Postgres image. Source files are archived and compressed, then stored using the git large file service.

#### Note for future versions

When a new database is released, download [the source files](http://download.bls.gov/pub/time.series/oe/) into the `docker-scripts/data` directory and review the data structure for changes/errors. The 2014 and 2015 OES dataset structure differed slightly from the 2013 structure; expect structural changes in subsequent datasets as well.

Before committing, archive and compress the source files (and then remove the originals). From the repository root directory:

    tar -cvpzf docker-scripts/data/data.tar.gz --exclude='.DS_Store' -C docker-scripts/data .
    rm -f docker-scripts/data/oe.*

#### Note for local development

The `fix_source_script.sh` script requires the GNU version of `sed` as well as `dos2unix`, which can be installed on Mac OS X using Homebrew:

    brew install gnu-sed --with-default-names dos2unix
