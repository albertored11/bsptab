PREFIX ?= /usr

all:
	@echo Run \'make install\' to install bsptab.

install:
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@cp -p tabc $(DESTDIR)$(PREFIX)/bin/tabc
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/tabc
	@cp -p tabbed-sub $(DESTDIR)$(PREFIX)/bin/tabbed-sub
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/tabbed-sub
	@cp -p tabbed-unsub $(DESTDIR)$(PREFIX)/bin/tabbed-unsub
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/tabbed-unsub

uninstall:
	@rm -rf $(DESTDIR)$(PREFIX)/bin/tabc
	@rm -rf $(DESTDIR)$(PREFIX)/bin/tabbed-sub
	@rm -rf $(DESTDIR)$(PREFIX)/bin/tabbed-unsub
