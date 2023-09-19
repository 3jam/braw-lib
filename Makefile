# braw
# see LICENSE file for copyright and license details.
.POSIX:

include config.mk

all: options braw

options:
	@echo braw build options:
	@echo "CFLAGS = $(CFLAGS)"
	@echo "CC     = $(CC)"

braw:
	$(CC) $(CFLAGS) -o braw.o -fPIC -c braw.c
	$(CC) $(CFLAGS) -o libbraw.so.$(VERSION) -shared braw.o $(INCLUDES)
	ar -crs libbraw.a braw.o

clean:
	rm -rf *.o *.so.* *.a

install: braw
	mkdir -p $(DESTDIR)$(PREFIX)/lib
	cp -f libbraw.so.$(VERSION) $(DESTDIR)$(PREFIX)/lib
	chmod 755 $(DESTDIR)$(PREFIX)/lib/libbraw.so.$(VERSION)
	cp -f libbraw.a $(DESTDIR)$(PREFIX)/lib
	chmod 755 $(DESTDIR)$(PREFIX)/lib/libbraw.a
	mkdir -p $(DESTDIR)$(PREFIX)/include
	cp -f braw.h $(DESTDIR)$(PREFIX)/include
	chmod 755 $(DESTDIR)$(PREFIX)/include/braw.h
	mkdir -p $(DESTDIR)$(MANPREFIX)/man3
	sed "s/VERSION/$(VERSION)/g" < braw.3 > $(DESTDIR)$(MANPREFIX)/man3/braw.3
	chmod 644 $(DESTDIR)$(MANPREFIX)/man3/braw.3

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/lib/libbraw.so.$(VERSION)
	rm -f $(DESTDIR)$(PREFIX)/lib/libbraw.a
	rm -f $(DESTDIR)$(MANPREFIX)/man3/braw.3

.PHONY: all options clean install uninstall
