# Copyright (C) 2001-2026  The Bochs Project
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

# Makefile for the iodev component of bochs


.SUFFIXES: .cc

prefix          = /usr/local
exec_prefix     = ${prefix}
srcdir          = ../../bochs-src/bochs/iodev
VPATH = ../../bochs-src/bochs/iodev
bindir          = ${exec_prefix}/bin
libdir          = ${exec_prefix}/lib
datarootdir     = ${prefix}/share
mandir          = ${datarootdir}/man
man1dir         = $(mandir)/man1
man5dir         = $(mandir)/man5
docdir          = $(datarootdir)/doc/bochs
sharedir        = $(datarootdir)/bochs
top_builddir    = ..
top_srcdir      = ../../bochs-src/bochs

SHELL = /bin/bash



CXX = /workspace/bochs-official-poc/emsdk/upstream/emscripten/em++
CXXFLAGS = -s EXPORTED_RUNTIME_METHODS=['callMain','FS','writeArrayToMemory'] -s ALLOW_MEMORY_GROWTH=1 -s ENVIRONMENT='web,node' -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES  
CPPFLAGS = $(BX_INCDIRS)  -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES

LDFLAGS = 
LIBS = 
RANLIB = /workspace/bochs-official-poc/emsdk/upstream/emscripten/emranlib
AR = /workspace/bochs-official-poc/emsdk/upstream/emscripten/emar
PLUGIN_PATH=${exec_prefix}/lib
top_builddir    = ..
LIBTOOL=$(SHELL) $(top_builddir)/libtool
WIN32_DLL_IMPORT_LIBRARY=../

BX_INCDIRS = -I.. -I$(srcdir)/.. -I../instrument/stubs -I$(srcdir)/../instrument/stubs
LOCAL_CXXFLAGS = $(MCH_CFLAGS)

GAME_LINK_OPTS = -lwinmm
GAME_LINK_OPTS_VCPP = winmm.lib
SER_LINK_OPTS = -lws2_32
SER_LINK_OPTS_VCPP = user32.lib ws2_32.lib
FDC_LINK_OPTS =
FDC_LINK_OPTS_VCPP = user32.lib
IODEV_DLL_TARGETS = 

PCIDEV_CXXFLAGS = -I$(srcdir)/../host/linux/pcidev

OBJS_THAT_CANNOT_BE_PLUGINS = \
  devices.o \
  virt_timer.o \
  slowdown_timer.o \
  $(MCH_OBJS)

OBJS_THAT_CAN_BE_PLUGINS = \
  pic.o \
  pit.o \
  fw_cfg.o \
  serial.o \
  parallel.o \
  floppy.o \
  keyboard.o \
  biosdev.o \
  cmos.o \
  harddrv.o \
  dma.o \
  unmapped.o \
  extfpuirq.o \
  speaker.o \
  ioapic.o \
   \
  pci.o pci2isa.o pci_ide.o acpi.o hpet.o \
   \
  

OBJS_THAT_SUPPORT_OTHER_PLUGINS = \
  acpi_tables.o \
  pit82c54.o \
  scancodes.o \
  serial_raw.o

NONPLUGIN_OBJS = $(OBJS_THAT_CANNOT_BE_PLUGINS) $(OBJS_THAT_CAN_BE_PLUGINS) $(OBJS_THAT_SUPPORT_OTHER_PLUGINS)
PLUGIN_OBJS = 

all: libiodev.a

plugins: 

plugins_gcc: $(PLUGIN_OBJS:%.o=libbx_%.la)

plugins_msvc: $(IODEV_DLL_TARGETS) bx_fw_cfg.dll bx_keyboard.dll bx_pit.dll bx_gameport.dll bx_serial.dll bx_floppy.dll

libiodev.a: $(NONPLUGIN_OBJS)
	rm -f  libiodev.a
	$(AR) rv $@ $(NONPLUGIN_OBJS)
	$(RANLIB) libiodev.a

# standard compile rule for C++ files
.cc.o:
	$(CXX) -c  $(CPPFLAGS) $(CXXFLAGS) $(LOCAL_CXXFLAGS) $< -o $@

pcidev.o : pcidev.cc
	$(CXX) -c  $(CPPFLAGS) $(CXXFLAGS) $(LOCAL_CXXFLAGS) $(PCIDEV_CXXFLAGS) $< -o $@

##### building plugins with libtool
%.lo: %.cc
	$(LIBTOOL) --mode=compile --tag CXX $(CXX) -c $(CPPFLAGS) $(CXXFLAGS) $(LOCAL_CXXFLAGS) $< -o $@

pcidev.lo : pcidev.cc
	$(LIBTOOL) --mode=compile --tag CXX $(CXX) -c $(CPPFLAGS) $(CXXFLAGS) $(LOCAL_CXXFLAGS) $(PCIDEV_CXXFLAGS) $< -o $@

libbx_%.la: %.lo
	$(LIBTOOL) --mode=link --tag CXX $(CXX) $(LDFLAGS) -module $< -o $@ -rpath $(PLUGIN_PATH)

# special link rules for plugins that require more than one object file
libbx_fw_cfg.la: fw_cfg.lo acpi_tables.lo
	$(LIBTOOL) --mode=link --tag CXX $(CXX) $(LDFLAGS) -module fw_cfg.lo acpi_tables.lo -o libbx_fw_cfg.la -rpath $(PLUGIN_PATH)

libbx_keyboard.la: keyboard.lo scancodes.lo
	$(LIBTOOL) --mode=link --tag CXX $(CXX) $(LDFLAGS) -module keyboard.lo scancodes.lo -o libbx_keyboard.la -rpath $(PLUGIN_PATH)

libbx_pit.la: pit82c54.lo pit.lo
	$(LIBTOOL) --mode=link --tag CXX $(CXX) $(LDFLAGS) -module pit82c54.lo pit.lo -o libbx_pit.la -rpath $(PLUGIN_PATH)

libbx_serial.la: serial.lo serial_raw.lo
	$(LIBTOOL) --mode=link --tag CXX $(CXX) $(LDFLAGS) -module serial.lo serial_raw.lo -o libbx_serial.la -rpath $(PLUGIN_PATH)

#### building DLLs for win32 (Cygwin and MinGW/MSYS)
bx_%.dll: %.o
	$(CXX) $(CXXFLAGS) -shared -o $@ $< $(WIN32_DLL_IMPORT_LIBRARY)

# special link rules for plugins with Cygwin, MinGW/MSYS and MSVC nmake
bx_fw_cfg.dll: fw_cfg.o acpi_tables.o
	 fw_cfg.o acpi_tables.o $(WIN32_DLL_IMPORT_LIBRARY)

bx_keyboard.dll: keyboard.o scancodes.o
	 keyboard.o scancodes.o $(WIN32_DLL_IMPORT_LIBRARY)

bx_pit.dll: pit82c54.o pit.o
	 pit82c54.o pit.o $(WIN32_DLL_IMPORT_LIBRARY)

bx_gameport.dll: gameport.o
	 gameport.o $(WIN32_DLL_IMPORT_LIBRARY) $(GAME_LINK_OPTS)

bx_serial.dll: serial.o serial_raw.o
	 serial.o serial_raw.o $(WIN32_DLL_IMPORT_LIBRARY) $(SER_LINK_OPTS)

bx_floppy.dll: floppy.o
	 floppy.o $(WIN32_DLL_IMPORT_LIBRARY) $(FDC_LINK_OPTS)



##### end DLL section

clean:
	rm -f  -rf .libs *.lo *.o *.la *.a *.dll *.exp *.lib

dist-clean: clean
	rm -f  Makefile makeincl.vc

###########################################
# dependencies generated by
#  gcc -MM -I.. -I../instrument/stubs *.cc | sed -e 's/\.cc/.cc/g'
#  gcc -MM -I.. -I../instrument/stubs *.cc | \
#     sed -e 's/\.cc/.cc/g' -e 's/\.o:/.lo:/g'
#
# This means that every source file is listed twice, once with a .o rule
# and then again with an identical .lo rule.  The .lo rules are used when
# building plugins.
###########################################
acpi.o: acpi.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h pci.h acpi.h virt_timer.h ../pc_system.h
acpi_tables.o: acpi_tables.cc ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h acpi_tables.h acpi_dsdt_aml.h
biosdev.o: biosdev.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h biosdev.h
busmouse.o: busmouse.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h busmouse.h
cmos.o: cmos.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h cmos.h virt_timer.h ../pc_system.h utctime.h \
 ../bx_debug/debug.h ../config.h ../osdep.h ../cpu/decoder/decoder.h \
 ../cpu/decoder/features.h
devices.o: devices.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../gui/keymap.h ../instrument/stubs/instrument.h \
 ../iodev/virt_timer.h ../pc_system.h ../iodev/slowdown_timer.h \
 ../iodev/sound/soundmod.h ../iodev/network/netmod.h \
 ../iodev/usb/usb_common.h ../iodev/usb/usb_pcap.h \
 ../iodev/hdimage/hdimage.h ../bx_debug/debug.h ../config.h ../osdep.h \
 ../cpu/decoder/decoder.h ../cpu/decoder/features.h
dma.o: dma.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h dma.h ../bx_debug/debug.h ../config.h \
 ../osdep.h ../cpu/decoder/decoder.h ../cpu/decoder/features.h
extfpuirq.o: extfpuirq.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h extfpuirq.h
floppy.o: floppy.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h hdimage/hdimage.h ../bx_debug/debug.h \
 ../config.h ../osdep.h ../cpu/decoder/decoder.h \
 ../cpu/decoder/features.h floppy.h
fw_cfg.o: fw_cfg.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h fw_cfg.h acpi_tables.h
gameport.o: gameport.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h gameport.h
harddrv.o: harddrv.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h harddrv.h hdimage/hdimage.h hdimage/cdrom.h
hpet.o: hpet.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h hpet.h ../bx_debug/debug.h ../config.h \
 ../osdep.h ../cpu/decoder/decoder.h ../cpu/decoder/features.h
ioapic.o: ioapic.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ioapic.h ../bx_debug/debug.h ../config.h ../osdep.h \
 ../cpu/decoder/decoder.h ../cpu/decoder/features.h
iodebug.o: iodebug.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h iodebug.h ../bx_debug/debug.h ../config.h ../osdep.h \
 ../cpu/decoder/decoder.h ../cpu/decoder/features.h
keyboard.o: keyboard.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h ../gui/keymap.h keyboard.h scancodes.h
parallel.o: parallel.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h parallel.h
pci2isa.o: pci2isa.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h pci.h pci2isa.h ../bx_debug/debug.h \
 ../config.h ../osdep.h ../cpu/decoder/decoder.h \
 ../cpu/decoder/features.h
pci.o: pci.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h pci.h ../bx_debug/debug.h ../config.h \
 ../osdep.h ../cpu/decoder/decoder.h ../cpu/decoder/features.h
pcidev.o: pcidev.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h
pci_ide.o: pci_ide.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h pci.h pci_ide.h
pic.o: pic.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h pic.h ../bx_debug/debug.h ../config.h \
 ../osdep.h ../cpu/decoder/decoder.h ../cpu/decoder/features.h
pit82c54.o: pit82c54.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h pit82c54.h ../bx_debug/debug.h ../config.h ../osdep.h \
 ../cpu/decoder/decoder.h ../cpu/decoder/features.h
pit.o: pit.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h pit.h pit82c54.h virt_timer.h ../pc_system.h speaker.h \
 ../bx_debug/debug.h ../config.h ../osdep.h ../cpu/decoder/decoder.h \
 ../cpu/decoder/features.h
scancodes.o: scancodes.cc ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../gui/gui.h ../gui/siminterface.h ../gui/paramtree.h \
 scancodes.h
serial.o: serial.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h serial.h
serial_raw.o: serial_raw.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h
slowdown_timer.o: slowdown_timer.cc ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../param_names.h ../gui/siminterface.h \
 ../gui/paramtree.h ../pc_system.h slowdown_timer.h
speaker.o: speaker.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h speaker.h sound/soundlow.h ../bxthread.h \
 sound/soundmod.h
unmapped.o: unmapped.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h unmapped.h ../bx_debug/debug.h ../config.h ../osdep.h \
 ../cpu/decoder/decoder.h ../cpu/decoder/features.h
virt_timer.o: virt_timer.cc ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../gui/siminterface.h ../gui/paramtree.h \
 ../param_names.h virt_timer.h ../pc_system.h
acpi.lo: acpi.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h pci.h acpi.h virt_timer.h ../pc_system.h
acpi_tables.lo: acpi_tables.cc ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h acpi_tables.h acpi_dsdt_aml.h
biosdev.lo: biosdev.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h biosdev.h
busmouse.lo: busmouse.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h busmouse.h
cmos.lo: cmos.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h cmos.h virt_timer.h ../pc_system.h utctime.h \
 ../bx_debug/debug.h ../config.h ../osdep.h ../cpu/decoder/decoder.h \
 ../cpu/decoder/features.h
devices.lo: devices.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../gui/keymap.h ../instrument/stubs/instrument.h \
 ../iodev/virt_timer.h ../pc_system.h ../iodev/slowdown_timer.h \
 ../iodev/sound/soundmod.h ../iodev/network/netmod.h \
 ../iodev/usb/usb_common.h ../iodev/usb/usb_pcap.h \
 ../iodev/hdimage/hdimage.h ../bx_debug/debug.h ../config.h ../osdep.h \
 ../cpu/decoder/decoder.h ../cpu/decoder/features.h
dma.lo: dma.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h dma.h ../bx_debug/debug.h ../config.h \
 ../osdep.h ../cpu/decoder/decoder.h ../cpu/decoder/features.h
extfpuirq.lo: extfpuirq.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h extfpuirq.h
floppy.lo: floppy.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h hdimage/hdimage.h ../bx_debug/debug.h \
 ../config.h ../osdep.h ../cpu/decoder/decoder.h \
 ../cpu/decoder/features.h floppy.h
fw_cfg.lo: fw_cfg.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h fw_cfg.h acpi_tables.h
gameport.lo: gameport.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h gameport.h
harddrv.lo: harddrv.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h harddrv.h hdimage/hdimage.h hdimage/cdrom.h
hpet.lo: hpet.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h hpet.h ../bx_debug/debug.h ../config.h \
 ../osdep.h ../cpu/decoder/decoder.h ../cpu/decoder/features.h
ioapic.lo: ioapic.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ioapic.h ../bx_debug/debug.h ../config.h ../osdep.h \
 ../cpu/decoder/decoder.h ../cpu/decoder/features.h
iodebug.lo: iodebug.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h iodebug.h ../bx_debug/debug.h ../config.h ../osdep.h \
 ../cpu/decoder/decoder.h ../cpu/decoder/features.h
keyboard.lo: keyboard.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h ../gui/keymap.h keyboard.h scancodes.h
parallel.lo: parallel.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h parallel.h
pci2isa.lo: pci2isa.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h pci.h pci2isa.h ../bx_debug/debug.h \
 ../config.h ../osdep.h ../cpu/decoder/decoder.h \
 ../cpu/decoder/features.h
pci.lo: pci.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h pci.h ../bx_debug/debug.h ../config.h \
 ../osdep.h ../cpu/decoder/decoder.h ../cpu/decoder/features.h
pcidev.lo: pcidev.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h
pci_ide.lo: pci_ide.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h pci.h pci_ide.h
pic.lo: pic.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h pic.h ../bx_debug/debug.h ../config.h \
 ../osdep.h ../cpu/decoder/decoder.h ../cpu/decoder/features.h
pit82c54.lo: pit82c54.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h pit82c54.h ../bx_debug/debug.h ../config.h ../osdep.h \
 ../cpu/decoder/decoder.h ../cpu/decoder/features.h
pit.lo: pit.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h pit.h pit82c54.h virt_timer.h ../pc_system.h speaker.h \
 ../bx_debug/debug.h ../config.h ../osdep.h ../cpu/decoder/decoder.h \
 ../cpu/decoder/features.h
scancodes.lo: scancodes.cc ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../gui/gui.h ../gui/siminterface.h ../gui/paramtree.h \
 scancodes.h
serial.lo: serial.cc iodev.h ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h serial.h
serial_raw.lo: serial_raw.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h
slowdown_timer.lo: slowdown_timer.cc ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../param_names.h ../gui/siminterface.h \
 ../gui/paramtree.h ../pc_system.h slowdown_timer.h
speaker.lo: speaker.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h ../pc_system.h speaker.h sound/soundlow.h ../bxthread.h \
 sound/soundmod.h
unmapped.lo: unmapped.cc iodev.h ../bochs.h ../config.h ../osdep.h \
 ../logio.h ../misc/bswap.h ../plugin.h ../extplugin.h ../param_names.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h unmapped.h ../bx_debug/debug.h ../config.h ../osdep.h \
 ../cpu/decoder/decoder.h ../cpu/decoder/features.h
virt_timer.lo: virt_timer.cc ../bochs.h ../config.h ../osdep.h ../logio.h \
 ../misc/bswap.h ../gui/siminterface.h ../gui/paramtree.h \
 ../param_names.h virt_timer.h ../pc_system.h
