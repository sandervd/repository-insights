TOPTARGETS := report clean

SUBDIRS := $(wildcard repositories/*/.)

help:
	@echo "Please have a look at README.md for execution instructions."
	exit 1
#	echo $(SUBDIRS)

$(TOPTARGETS): $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

dependencies:
	# Create a list of hashes of repos folders that need to exist.
	# Note: the $ in the awk command is dubble escaped (remove $ when executing direct in shell)
	cat repositories.csv | sort | xargs -I ! sh -c "echo ! | sha1sum | cut -d' ' -f1 | awk '{print \"! \"\$$1}'" > repositories.lookup.csv
	cat repositories.lookup.csv | cut -d' ' -f2 | sort > repositories.required.csv
	# Create a list of hashes of current tracked repos.
	find repositories/* -maxdepth 1 -type d | cut -d/ -f2 | xargs -I ! sh -c "echo ! | sha1sum |cut -d' ' -f1" | sort > repositories.tracked.csv
	# Folders to create
	comm -23 repositories.required.csv repositories.tracked.csv > repositories.add.csv
	#Folders to delete'
	comm -13 repositories.required.csv repositories.tracked.csv > repositories.delete.csv

	# Add
	cat repositories.add.csv | xargs -I % sh -c "grep '%' repositories.lookup.csv | ./create-makefile.sh"


clean: $(SUBDIRS)
	rm repositories/* -rf

.PHONY: $(TOPTARGETS) $(SUBDIRS)
