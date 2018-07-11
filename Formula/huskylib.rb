class Huskylib < Formula
  desc "Libraries for the Husky Project applications"
  homepage "https://github.com/huskyproject/huskylib"
  head "https://github.com/huskyproject/huskylib.git"

  patch :DATA
  def install
    inreplace "Makefile", "../huskymak.cfg", "huskymak.cfg"
    system "make"
    man1.install "man/gnmsgid.1"
    lib.install "libhusky.a"
    lib.install Dir["libhusky.dy*"]
    include.install "huskylib"
    bin.install "gnmsgid"
  end

end

__END__
diff -Naur huskylib.orig/Makefile huskylib/Makefile
--- huskylib.orig/Makefile	2018-07-11 22:53:55.000000000 +0200
+++ huskylib/Makefile	2018-07-12 00:04:08.000000000 +0200
@@ -54,8 +54,7 @@
 	$(LD) $(LFLAGS) -o $(TARGETDLL).$(VER) $(OBJS)
   else
 $(TARGETDLL).$(VER): $(OBJS)
-	$(CC) -shared -Wl,-soname,$(TARGETDLL).$(VERH) \
-          -o $(TARGETDLL).$(VER) $(OBJS)
+	$(CC) -shared -o $(TARGETDLL).$(VER) $(OBJS)
   endif
 	$(LN) $(LNOPT) $(TARGETDLL).$(VER) $(TARGETDLL).$(VERH) ;\
 	$(LN) $(LNOPT) $(TARGETDLL).$(VER) $(TARGETDLL)
diff -Naur huskylib.orig/huskymak.cfg huskylib/huskymak.cfg
--- huskylib.orig/huskymak.cfg	2018-07-11 22:53:55.000000000 +0200
+++ huskylib/huskymak.cfg	2018-07-12 00:01:17.000000000 +0200
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
