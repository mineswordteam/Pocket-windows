# Copyright (C) 2001  The Bochs Project
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA



.SUFFIXES: .cc

srcdir = /workspace/bochs-src/bochs/instrument/stubs
VPATH = /workspace/bochs-src/bochs/instrument/stubs

SHELL = /bin/bash



CC = emcc
CFLAGS = -g -O2 -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES 
CXX = em++
CXXFLAGS = -g -O2 -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES 
CPPFLAGS =  -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES

LDFLAGS = -s INITIAL_MEMORY=64MB -s MAXIMUM_MEMORY=128MB -s ALLOW_MEMORY_GROWTH=1
LIBS = 
RANLIB = emranlib


# ===========================================================
# end of configurable options
# ===========================================================


BX_OBJS = \
  instrument.o

BX_INCLUDES =

BX_INCDIRS = -I../.. -I$(srcdir)/../.. -I. -I$(srcdir)/.

.cc.o:
	$(CXX) -c $(BX_INCDIRS) $(CPPFLAGS) $(CXXFLAGS) $< -o $@


.c.o:
	$(CC) -c $(BX_INCDIRS) $(CPPFLAGS) $(CFLAGS) $< -o $@



libinstrument.a: $(BX_OBJS)
	rm -f  libinstrument.a
	ar rv $@ $(BX_OBJS)
	$(RANLIB) libinstrument.a

$(BX_OBJS): $(BX_INCLUDES)


clean:
	rm -f  *.o
	rm -f  *.a

dist-clean: clean
	rm -f  Makefile
