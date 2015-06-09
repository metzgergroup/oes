## Re-create the Occupation Employment Statistics database

### 1. Install required binaries

- `zsh`
- GNU version of `sed`
- `dos2unix` (to fix line-endings in source files)
    ```
    brew install zsh dos2unix gnu-sed --with-default-names
    ```

### 2. Clone repo

    git clone https://github.com/bfin/oes.git

### 3. Download [source text files](http://download.bls.gov/pub/time.series/oe/) into `source` directory

### 4. Create local database

Executing the `create_database.zsh` script will sanitize the source files, create the database locally (named `oes` by default), and backup to a file (named `oes.dump` by default). Note: this script was created to work with the 2014 OES dataset structure (published May 2015), which differed from the 2013 structure. Expect subsequent datasets to change as well.

    zsh create_database.zsh

### 5. Create online database

If you already have an online database named `oes`:

    psql --host=<endpoint> --port=<port> --username=<user> --dbname=oes

If no online database exists yet but you have a server instance running, connect to the `template1` database:

    psql --host=<endpoint> --port=<port> --username=<user> --dbname=template1

Then create the `oes` database from within `psql`:

    CREATE DATABASE oes;

### 6. Copy to online database

Note: this is going to take a while. Use the `verbose` flag so it doesn't look as though the command isn't working.

    pg_restore --host=<endpoint> --port=<port> --username=<user> --dbname=oes --schema=public --no-owner --no-privileges --no-tablespaces --verbose oes.dump
