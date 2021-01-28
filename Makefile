.SUFFIXES:
.DEFAULT_GOAL := all
repos!=cat repositories.required.csv 2>/dev/null | xargs -I % sh -c "grep '%' repositories.lookup.csv" | cut -d' ' -f2 |  tr '\n' ' '

-include include.mk

all: remove-stale ${repos}

help:
	@echo "Please have a look at README.md for execution instructions."
	exit 1


# Only rebuild the repository lists when the csv changed.
include.mk:: repositories.required.csv
	# Add
	xargs -a repositories.required.csv -I % sh -c "grep '%' repositories.lookup.csv | ./create-makefile.sh" > include.mk

# Removes repositories that are no longer monitored.
remove-stale: repositories.delete.csv
	xargs -a repositories.delete.csv -I % sh -c "rm -rf repositories/%"

repositories.lookup.csv: repositories.csv
	# Create a list of hashes of repos folders that need to exist.
	# Note: the $ in the awk command is dubble escaped (remove $ when executing direct in shell)
	cat repositories.csv | sort | xargs -I ! sh -c "echo ! | sha1sum | cut -d' ' -f1 | awk '{print \"! \"\$$1}'" > repositories.lookup.csv

repositories.required.csv: repositories.lookup.csv
	cat repositories.lookup.csv | cut -d' ' -f2 | sort > repositories.required.csv

repositories.tracked.csv: repositories
	# Create a list of hashes of current tracked repos.
	find repositories/* -maxdepth 0 -type d | cut -d/ -f2 | sort > repositories.tracked.csv

repositories.add.csv: repositories.required.csv repositories.tracked.csv
	# Folders to create
	comm -23 repositories.required.csv repositories.tracked.csv > repositories.add.csv

repositories.delete.csv: repositories.required.csv repositories.tracked.csv
	#Folders to delete'
	comm -13 repositories.required.csv repositories.tracked.csv > repositories.delete.csv

clean: 
	rm include.mk
	rm repositories.*.csv
	rm repositories/* -rf

.PHONY: help clean remove-stale
