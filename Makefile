#
#   DMI Decode
#   BIOS Decode
#   VPD Decode
#
#   Copyright (C) 2000-2002 Alan Cox <alan@redhat.com>
#   Copyright (C) 2002-2007 Jean Delvare <khali@linux-fr.org>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#

CC      = /usr/bin/i586-mingw32msvc-gcc 
CFLAGS  = -W -Wall -Wshadow -Wstrict-prototypes -Wpointer-arith -Wcast-qual \
          -Wcast-align -Wwrite-strings -Wmissing-prototypes -Winline -Wundef
#CFLAGS += -DBIGENDIAN
#CFLAGS += -DALIGNMENT_WORKAROUND

# When debugging, disable -O2 and enable -g.
CFLAGS += -O3
#CFLAGS += -g

# Pass linker flags here
LDFLAGS =

DESTDIR =
prefix  = C:/Progra~1/DmiDecode
sbindir = $(prefix)/sbin
mandir  = $(prefix)/man
man8dir = $(mandir)/man8
docdir  = $(prefix)/doc

INSTALL         := install
INSTALL_DATA    := $(INSTALL) -m 644
INSTALL_DIR     := $(INSTALL) -m 755 -d
INSTALL_PROGRAM := $(INSTALL) -m 755
RM              := rm -f
EXEEXT          := ".exe"

PROGRAMS := dmidecode$(EXEEXT)


all : $(PROGRAMS)

#
# Programs
#

dmidecode$(EXEEXT) : dmidecode.o dmiopt.o dmioem.o util.o winsmbios.o dmidecode-res.o 
	$(CC) $(LDFLAGS) dmidecode.o dmiopt.o dmioem.o util.o winsmbios.o dmidecode-res.o -o $@

biosdecode$(EXEEXT) : biosdecode.o util.o winsmbios.o biosdecode-res.o
	$(CC) $(LDFLAGS) biosdecode.o util.o winsmbios.o biosdecode-res.o -o $@

ownership$(EXEEXT) : ownership.o util.o winsmbios.o ownership-res.o
	$(CC) $(LDFLAGS) ownership.o util.o winsmbios.o ownership-res.o -o $@

vpddecode$(EXEEXT) : vpddecode.o vpdopt.o util.o winsmbios.o vpddecode-res.o
	$(CC) $(LDFLAGS) vpddecode.o vpdopt.o util.o winsmbios.o vpddecode-res.o -o $@

#
# Objects
#

dmidecode.o : dmidecode.c version.h types.h util.h config.h dmidecode.h \
	      dmiopt.h dmioem.h
	$(CC) $(CFLAGS) -c $< -o $@

dmiopt.o : dmiopt.c config.h types.h util.h dmidecode.h dmiopt.h
	$(CC) $(CFLAGS) -c $< -o $@

dmioem.o : dmioem.c types.h dmidecode.h dmioem.h
	$(CC) $(CFLAGS) -c $< -o $@

biosdecode.o : biosdecode.c version.h types.h util.h config.h 
	$(CC) $(CFLAGS) -c $< -o $@

ownership.o : ownership.c version.h types.h util.h config.h
	$(CC) $(CFLAGS) -c $< -o $@

vpddecode.o : vpddecode.c version.h types.h util.h config.h vpdopt.h
	$(CC) $(CFLAGS) -c $< -o $@

vpdopt.o : vpdopt.c config.h util.h vpdopt.h
	$(CC) $(CFLAGS) -c $< -o $@

util.o : util.c types.h util.h config.h
	$(CC) $(CFLAGS) -c $< -o $@
	
winsmbios.o : winsmbios.c types.h winsmbios.h config.h
	$(CC) $(CFLAGS) -c $< -o $@
	

#
# Commands
#

strip : $(PROGRAMS)
	strip $(PROGRAMS)

install : install-bin install-man install-doc

uninstall : uninstall-bin uninstall-man uninstall-doc

install-bin : $(PROGRAMS)
	$(INSTALL_DIR) $(DESTDIR)$(sbindir)
	for program in $(PROGRAMS) ; do \
	$(INSTALL_PROGRAM) $$program $(DESTDIR)$(sbindir) ; done

uninstall-bin :
	for program in $(PROGRAMS) ; do \
	$(RM) $(DESTDIR)$(sbindir)/$$program ; done

install-man :
	$(INSTALL_DIR) $(DESTDIR)$(man8dir)
	for program in $(PROGRAMS) ; do \
	$(INSTALL_DATA) $(SRCDIRSL)man/$${program%.exe}.8 $(DESTDIR)$(man8dir) ; done

uninstall-man :
	for program in $(PROGRAMS) ; do \
	$(RM) $(DESTDIR)$(man8dir)/$$program.8 ; done

install-doc :
	$(INSTALL_DIR) $(DESTDIR)$(docdir)
	$(INSTALL_DATA) $(SRCDIRSL)README $(DESTDIR)$(docdir)
	$(INSTALL_DATA) $(SRCDIRSL)CHANGELOG $(DESTDIR)$(docdir)
	$(INSTALL_DATA) $(SRCDIRSL)AUTHORS $(DESTDIR)$(docdir)

uninstall-doc :
	$(RM) -r $(DESTDIR)$(docdir)

clean :
	$(RM) *.o $(PROGRAMS) core
