class Fidoconf < Formula
  desc "Common FTN configuration library"
  homepage "https://github.com/huskyproject/fidoconf"
  head "https://github.com/huskyproject/fidoconf.git"

  depends_on "huskylib"
  depends_on "smapi"

  patch :DATA
  def install
    inreplace "Makefile", "../huskymak.cfg", "huskymak.cfg"
    inreplace "doc/Makefile", "../../huskymak.cfg", "../huskymak.cfg"
    system "make"
    rm "fidoconf/fc2tor_g.h"
    rm "fidoconf/fecfg146.h"
    rm "fidoconf/tokens.h"
    lib.install Dir["libfidoconfig.*"]
    include.install "fidoconf"
    man1.install Dir["man/*.1"]
    ln_s "fconf2.1", "#{man1}/fconf2aquaed.1"
    ln_s "fconf2.1", "#{man1}/fconf2areasbbs.pl.1"
    ln_s "fconf2.1", "#{man1}/fconf2binkd.1"
    ln_s "fconf2.1", "#{man1}/fconf2dir.1"
    ln_s "fconf2.1", "#{man1}/fconf2fidogate.1"
    ln_s "fconf2.1", "#{man1}/fconf2golded.1"
    ln_s "fconf2.1", "#{man1}/fconf2msged.1"
    ln_s "fconf2.1", "#{man1}/fconf2na.pl.1"
    ln_s "fconf2.1", "#{man1}/fconf2squish.1"
    ln_s "fconf2.1", "#{man1}/fconf2tornado.1"
    ln_s "fconf2.1", "#{man1}/fecfg2fconf.1"
    bin.install "fconf2aquaed"
    bin.install "fconf2binkd"
    bin.install "fconf2fidogate"
    bin.install "fconf2golded"
    bin.install "fconf2msged"
    bin.install "fconf2squish"
    bin.install "fconf2tornado"
    bin.install "fecfg2fconf"
    bin.install "linked"
    bin.install "tparser"
    bin.install "util/fconf2areasbbs.pl"
    bin.install "util/fconf2na.pl"
    bin.install "util/linkedto"
    bin.install "util/sq2fc.pl"
  end
end

__END__
--- fidoconf.orig/Makefile	2018-07-12 02:18:37.000000000 +0200
+++ fidoconf/Makefile	2018-07-12 02:36:28.000000000 +0200
@@ -75,7 +75,7 @@
 progs: commonprogs

 ifeq ($(DYNLIBS), 1)
-  TARGET = $(TARGETDLL)
+  TARGET = $(TARGETLIB)
   all: commonlibs $(TARGETDLL).$(VER)
 	$(MAKE) progs
 	(cd doc && $(MAKE) all)
--- fidoconf.orig/Makefile	2018-07-12 01:33:16.000000000 +0200
+++ fidoconf/Makefile	2018-07-12 01:34:25.000000000 +0200
@@ -92,8 +92,7 @@
 	$(LD) $(LFLAGS) $(EXENAMEFLAG) $(TARGETDLL).$(VER) $(LOBJS) $(LIBS)
 else
 $(TARGETDLL).$(VER): $(LOBJS)
-	$(CC) $(LFLAGS) -shared -Wl,-soname,$(TARGETDLL).$(VERH) \
-	-o $(TARGETDLL).$(VER) $(LOBJS) $(LIBS)
+	$(CC) -shared $(LFLAGS) -o $(TARGETDLL).$(VER) $(LOBJS) $(LIBS)
 endif
 	$(LN) $(LNOPT) $(TARGETDLL).$(VER) $(TARGETDLL).$(VERH) ;\
 	$(LN) $(LNOPT) $(TARGETDLL).$(VER) $(TARGETDLL)
--- fidoconf.orig/huskymak.cfg	2018-07-11 22:53:55.000000000 +0200
+++ fidoconf/huskymak.cfg	2018-07-12 00:01:17.000000000 +0200
@@ -2,9 +2,9 @@
 # Don't use it for any other purposes!

 ARCH:=$(shell getconf LONG_BIT)
-PREFIX=/usr
+PREFIX=/usr/local
 ifeq ($(ARCH), 64)
-    LIBDIR=$(PREFIX)/lib64
+    LIBDIR=$(PREFIX)/lib
 else
     LIBDIR=$(PREFIX)/lib
 endif
@@ -34,7 +34,7 @@
 DEBUG=0
 PERL=1
 USE_HPTZIP=0
-DYNLIBS=0
+DYNLIBS=1
 EXENAMEFLAG=-o
 WARNFLAGS=-Wall
 OPTCFLAGS=-c -s -O3 -fomit-frame-pointer -fstrength-reduce -fPIC
@@ -64,5 +64,5 @@
 _EXE=
 _OBJ=.o
 _LIB=.a
-_DLL=.so
+_DLL=.dylib
 _TPU=.ppu
