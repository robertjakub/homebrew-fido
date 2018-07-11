class Smapi < Formula
  desc "Squish Messagebase API"
  homepage "https://github.com/huskyproject/smapi"
  head "https://github.com/huskyproject/smapi.git"

  depends_on "huskylib"

  patch :DATA
  def install
    inreplace "Makefile", "../huskymak.cfg", "huskymak.cfg"
    system "make"
    lib.install "libsmapi.a"
    lib.install Dir["libsmapi.dy*"]
    include.install "smapi"
  end
end

__END__
diff -Naur smapi.orig/Makefile smapi/Makefile
--- smapi.orig/Makefile	2018-05-31 13:54:53.000000000 +0200
+++ smapi/Makefile	2018-07-12 00:52:52.000000000 +0200
@@ -54,9 +54,10 @@
 	$(LD) $(LFLAGS) -o $(TARGETDLL).$(VER) $(OBJS) -L$(LIBDIR) $(LIBS)
   else
 $(TARGETDLL).$(VER): $(OBJS)
-	$(CC) -shared -Wl,-soname,$(TARGETDLL).$(VERH) \
-          -o $(TARGETDLL).$(VER) $(OBJS) -L$(LIBDIR) $(LIBS)
+	$(CC) -shared -o $(TARGETDLL).$(VER) $(OBJS) -L$(LIBDIR) $(LIBS)
   endif
+	$(LN) $(LNOPT) $(TARGETDLL).$(VER) $(TARGETDLL).$(VERH) ;\
+	$(LN) $(LNOPT) $(TARGETDLL).$(VER) $(TARGETDLL)

 instdyn: $(TARGETLIB) $(TARGETDLL).$(VER)
 	-$(MKDIR) $(MKDIROPT) $(DESTDIR)$(DIRSEP)$(LIBDIR)
diff -Naur smapi.orig/huskymak.cfg smapi/huskymak.cfg
--- smapi.orig/huskymak.cfg	2018-07-11 22:53:55.000000000 +0200
+++ smapi/huskymak.cfg	2018-07-12 00:01:17.000000000 +0200
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
