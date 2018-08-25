SHELL = /bin/bash
IMAGE_NAME = 899239495551.dkr.ecr.us-east-2.amazonaws.com/oes
SOURCE_DIR = docker-scripts/data
PG_VERSION = latest
SED1 = sed -e 's/[ \t]*$$//' -e 's/ \+/ /g' -e 's/ \t/\t/g' -e 's/\t /\t/g' -e 's/\t/|/g'
SED2 = sed -e 's/ \+//g' -e 's/\t\+$$/\t/g' -e 's/\t-\t/\t\t/g' -e 's/,//g' -e 's/\t/|/g'

.PHONY: download fix build push snapshot clean

download:
	wget \
	    --no-parent \
	    --no-directories \
	    --accept "oe.*" \
	    --reject "*.AllData" \
	    --directory-prefix=${SOURCE_DIR} \
	    -r \
	    https://download.bls.gov/pub/time.series/oe/

	tar -cvpzf \
	    ${SOURCE_DIR}/data.tar.gz \
	    --exclude='.DS_Store' \
	    -C ${SOURCE_DIR} \
	    .

fix:
	@echo "Converting source files to Unix format..."
	@find ${SOURCE_DIR}/* -type f ! -name *.tar.gz -exec dos2unix {} \;

	@echo "Sanitizing source files..."
	# For files with a mandatory last field:
	# (1) Remove trailing spaces and tabs
	# (2) Reduce multiple spaces to single spaces
	# (3) Replace a space followed by a tab with just a tab
	# (4) Replace a tab followed by a space with just a tab
	# (5) Replace all tabs with pipes (for delimiter)
	${SED1} -i ${SOURCE_DIR}/oe.area
	${SED1} -i ${SOURCE_DIR}/oe.areatype
	${SED1} -i ${SOURCE_DIR}/oe.datatype
	${SED1} -i ${SOURCE_DIR}/oe.footnote
	${SED1} -i ${SOURCE_DIR}/oe.industry
	${SED1} -i ${SOURCE_DIR}/oe.occupation
	${SED1} -i ${SOURCE_DIR}/oe.seasonal
	${SED1} -i ${SOURCE_DIR}/oe.sector
	${SED1} -i ${SOURCE_DIR}/oe.series

	# For files with an optional last field:
	# (1) Remove all spaces (but leave tabs)
	# (2) Replace multiple trailing tabs with a single tab (error in dataset)
	# (3) Remove hyphens when surrounded by tabs (used to indicate null values)
	# (4) Remove all commas
	# (5) Replace all tabs with pipes (for delimiter)
	${SED2} -i ${SOURCE_DIR}/oe.data.*

	@echo "Removing header lines from data files..."
	for file in ${SOURCE_DIR}/*; do \
	    if [[ $$file != *oe.txt && $$file != *oe.contacts && $$file != *.tar.gz ]]; then \
	        sed -i '1d' $$file; \
	    fi; \
	done

build:
	docker build \
	    --build-arg PG_VERSION=$(PG_VERSION) \
	    --tag $(IMAGE_NAME):$(shell cat ${SOURCE_DIR}/oe.release | awk 'END {print $$1}') \
	    .

push:
	docker push $(IMAGE_NAME):$(shell cat ${SOURCE_DIR}/oe.release | awk 'END {print $$1}')

clean:
	find ${SOURCE_DIR} -type f -not -name '*.tar.gz' -delete
