.POSIX:
.SUFFIXES:

HARE ?= hare
HAREFLAGS ?=
HAREPATH ?=
HARESRCDIR=$(SRCDIR)/hare
THIRDPARTYDIR=$(HARESRCDIR)/third-party
DESTDIR ?=
PREFIX ?= /usr/local
BINDIR ?= ${PREFIX}/bin
INSTALL := install
VARS =LD_LIBRARY_PATH=/usr/lib64:${LD_LIBRARY_PATH}
LIBS =

bunny: cmd/bunny.ha
	mkdir -p out/bin
	$(VARS) $(HAREPATH) $(VARS) $(HARE) build $(LIBS) $(HAREFLAGS) -v -o out/bin/$@ $<

all: clean bunny install-lib
	$(INSTALL) -v -m755 out/bin/bunny $(DESTDIR)$(BINDIR)

install: clean bunny
	$(INSTALL) -v -m755 out/bin/bunny $(DESTDIR)$(BINDIR)

install-lib:
	mkdir -p $(DESTDIR)$(THIRDPARTYDIR)/bunny
	install -m644 bunny/*.ha $(DESTDIR)$(THIRDPARTYDIR)/bunny

uninstall:
	$(RM) $(DESTDIR)$(BINDIR)/bunny

run: bunny
	$(VARS) $(HAREPATH) $(VARS) $(HARE) run $(LIBS) $(HAREFLAGS) -v cmd
	
clean:
	$(RM) -rv out
	$(HARE) cache -c
	
.PHONY: clean install
