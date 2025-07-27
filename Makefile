.POSIX:
.SUFFIXES:

HARE ?= hare
HAREFLAGS ?=
HAREPATH ?=
SRCDIR ?= /usr/local/src
HARESRCDIR=$(SRCDIR)/hare
THIRDPARTYDIR=$(HARESRCDIR)/third-party
VERBOSITY ?= -v
DESTDIR ?=
PREFIX ?= /usr/local
BINDIR ?= ${PREFIX}/bin
INSTALL := install
VARS =LD_LIBRARY_PATH=/usr/lib64:${LD_LIBRARY_PATH}
LIBS =

bunny: cmd/bunny.ha
	mkdir -p out/bin
	$(VARS) $(HAREPATH) $(VARS) $(HARE) build $(LIBS) $(HAREFLAGS) $(VERBOSITY) -o out/bin/$@ $<

all: clean bunny install-lib
	$(INSTALL) $(VERBOSITY) -m755 out/bin/bunny $(DESTDIR)$(BINDIR)

install: clean bunny
	$(INSTALL) $(VERBOSITY) -m755 out/bin/bunny $(DESTDIR)$(BINDIR)

check: tests
	$(VARS) $(HAREPATH) $(VARS) $(HARE) test $(LIBS) $(HAREFLAGS) $(VERBOSITY) $<

install-lib:
	mkdir -p $(DESTDIR)$(THIRDPARTYDIR)/
	cp -rfv bunny $(DESTDIR)$(THIRDPARTYDIR)/

uninstall:
	$(RM) $(DESTDIR)$(BINDIR)/bunny

run: bunny
	$(VARS) $(HAREPATH) $(VARS) $(HARE) run $(LIBS) $(HAREFLAGS) $(VERBOSITY) cmd $<
	
clean:
	$(RM) -rv out
	$(HARE) cache -c
	
.PHONY: all clean install bunny install-lib
