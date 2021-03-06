.PHONY: init
init: clone-gaia init-hg init-env

.PHONY: update
update: update-gaia update-hg

.PHONY: add-locales
add-locales:
	mkdir -p locales
	./locales.sh add $(LOCALES)

.PHONY: remove-locales
remove-locales:
	./locales.sh remove $(LOCALES)

.PHONY: find-dupl-locales
find-dupl-locales:
	./locales.sh dupl $(LOCALES)

.PHONY: clone-gaia
clone-gaia:
	@(if [ ! -d 'gaia' ]; then\
	    git clone https://github.com/mozilla-b2g/gaia;\
	    git --git-dir=gaia/.git --work-tree=gaia/ checkout v1-train;\
	  fi)

.PHONY: init-hg
init-hg:
	./locales.sh init $(LOCALES)

.PHONY: init-env
init-env:
	@(if [ ! -d 'env' ]; then\
	    virtualenv env;\
	    env/bin/pip install marionette_client;\
	    env/bin/pip install Pillow;\
	  fi)

.PHONY: update-gaia
update-gaia:
	git --git-dir=gaia/.git fetch
	git --git-dir=gaia/.git --work-tree=gaia/ merge origin/v1-train

.PHONY: update-hg
update-hg:
	./locales.sh update $(LOCALES)

.PHONY: runscripts
runscripts:
	./runscripts.sh

.PHONY: html-results
html-results:
	mkdir -p html_results
	env/bin/python html_generator.py
