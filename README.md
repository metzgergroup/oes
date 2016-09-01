# Occupation Employment Statistics database

This repo provides instructions to re-create the OES database in a Docker image.

---

### Step 1: Prepare

1. Clone repository
2. Install requirements
3. Adjust source files
4. Clean Docker resources

Clone this repository:

    git lfs clone https://gitlab.com/metzger-group/oes.git

**Note the `lfs` in the command. The source files and backup archive are stored in the git large file service. Standard `git clone` operations are significantly slower than `git lfs clone`.**

Install the requirements:

- GNU version of `sed`
- `dos2unix` (to fix line-endings in source files)

    ```
    brew install dos2unix gnu-sed --with-default-names
    ```

Run the `fix_source_files.sh` script to fix inconsistencies in the source files. (This will create a new directory -- named `working` by default -- and move the fixed source files into it.)

    sh fix_source_files.sh

Make sure old services and containers are removed:

    docker-compose --file docker-compose.create.yml down --volumes
    docker-compose --file docker-compose.backup.yml down --volumes

#### Note for future versions

When a new database is released, download [the source files](http://download.bls.gov/pub/time.series/oe/) into the `source` directory.

**Note: these instructions were created to work with the 2014 OES dataset structure, which differed from the 2013 structure. Expect subsequent datasets to change as well.**

---

### Step 2: Create

1. Start new Postgres container with entryscript, source files, and blank data volume attached
2. Script will create the database
3. Shut down the database gracefully

Re-create the database from the included initialization scripts and source text files by mounting them in the Postgres container:

    docker-compose --file docker-compose.create.yml up

When the installation is complete, gracefully stop the database server and remove the container:

    docker-compose --file docker-compose.create.yml down

---

### Step 3: Archive

The `docker-compose.backup.yml` file instructs docker to start a new non-Postgres container with the local backup directory and the named data volume both mounted as volumes. The container then archives all of the data from the data volume into the local backup directory.

    docker-compose --file docker-compose.backup.yml up

When the archive operation is complete, stop and remove the container and data volume:

    docker-compose --file docker-compose.backup.yml down --volumes

---

### Step 4: Registry

The default data directory in the official Postgres image is mounted as a volume and cannot be persisted in the same image. The included Dockerfile extracts the data archive into a directory in a Postgres container and sets the PGDATA environment variable so the server knows where to look for the data:

    docker build --tag registry.gitlab.com/metzger-group/oes:latest --tag registry.gitlab.com/metzger-group/oes:2014 .

Push image to the registry:

    docker login registry.gitlab.com
    docker push registry.gitlab.com/metzger-group/oes

Pull image from the registry (on another computer):

    docker pull registry.gitlab.com/metzger-group/oes
