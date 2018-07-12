class Hpt < Formula
  desc "HPT - the Husky Project tosser"
  homepage "https://github.com/huskyproject/hpt"
  head "https://github.com/huskyproject/hpt.git"

  depends_on "fidoconf"
  depends_on "areafix"

  patch :DATA
  def install
    system "make"
    bin.install "hpt"
    bin.install "hptlink"
    bin.install "hpttree"
    bin.install "pktinfo"
    bin.install "txt2pkt"
    man1.install Dir["man/*.1"]
    Dir.chdir('fidoroute')
    system "make"
    bin.install "fidoroute"
    man1.install "fidoroute.1"
    man5.install "fidoroute.conf.5"
  end
end

__END__
diff -Naur hpt-20180712-56355-yefv0i/Makefile hpt-20180712-40724-1yzqa7d/Makefile
--- hpt-20180712-56355-yefv0i/Makefile	2018-07-12 10:58:05.000000000 +0200
+++ hpt-20180712-40724-1yzqa7d/Makefile	2018-07-12 08:00:45.000000000 +0200
@@ -6,7 +6,7 @@
 # RPM build requires all files to be in the source directory
 include huskymak.cfg
 else
-include ../huskymak.cfg
+include huskymak.cfg
 endif

 SRC_DIR = src$(DIRSEP)
@@ -31,8 +31,8 @@
 endif

 ifeq ($(PERL), 1)
-  CFLAGS += -DDO_PERL `perl -MExtUtils::Embed -e ccopts`
-  PERLLIBS = `perl -MExtUtils::Embed -e ldopts`
+  CFLAGS += -DDO_PERL `perl -MExtUtils::Embed -e ccopts | sed -e 's/-arch [^ ]\{1,\}//g'`
+  PERLLIBS = `perl -MExtUtils::Embed -e ldopts | sed -e 's/-arch [^ ]\{1,\}//g'`
   PERLOBJ = perl$(_OBJ)
 endif

diff -Naur hpt-20180712-56355-yefv0i/huskymak.cfg hpt-20180712-40724-1yzqa7d/huskymak.cfg
--- hpt-20180712-56355-yefv0i/huskymak.cfg	2018-07-12 03:10:51.000000000 +0200
+++ hpt-20180712-40724-1yzqa7d/huskymak.cfg	2018-07-12 10:55:39.000000000 +0200
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
@@ -34,10 +34,10 @@
 DEBUG=0
 PERL=1
 USE_HPTZIP=0
-DYNLIBS=0
+DYNLIBS=1
 EXENAMEFLAG=-o
 WARNFLAGS=-Wall
-OPTCFLAGS=-c -s -O3 -fomit-frame-pointer -fstrength-reduce -fPIC
+OPTCFLAGS=-c -s -O3 -fomit-frame-pointer -fstrength-reduce -fPIC -m64
 ifeq ( $(DYNLIBS), 0 )
   ifeq ($(OSTYPE), UNIX)
     WARNFLAGS+= -static
@@ -64,5 +64,5 @@
 _EXE=
 _OBJ=.o
 _LIB=.a
-_DLL=.so
+_DLL=.dylib
 _TPU=.ppu
diff -Naur hpt-20180712-56355-yefv0i/src/hptlink.c hpt-20180712-40724-1yzqa7d/src/hptlink.c
--- hpt-20180712-56355-yefv0i/src/hptlink.c	2018-07-12 03:10:51.000000000 +0200
+++ hpt-20180712-40724-1yzqa7d/src/hptlink.c	2018-07-12 08:11:49.000000000 +0200
@@ -83,7 +83,7 @@
 #define LOGFILENAME "hptlink.log"

 s_log        *hptlink_log = NULL;
-s_fidoconfig *config;
+//s_fidoconfig *config;

 int singleRepl = 1;
 int hardSearch = 0;
@@ -102,7 +102,7 @@
 long links_total=0L;
 long links_ignored=0L;

-char *versionStr;
+//char *versionStr;

 char *skipReSubj ( char *subjstr )
 {
