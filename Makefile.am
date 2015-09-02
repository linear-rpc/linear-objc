SUBDIRS = . include src

all-local:
	(cd deps/linear-cpp; $(MAKE))

install-data-local:
	(cd deps/linear-cpp; $(MAKE) install)

uninstall-local:
	(cd deps/linear-cpp; $(MAKE) uninstall)

clean-local:
	(cd deps/linear-cpp; $(MAKE) clean)
	rm -f *~
