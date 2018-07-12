class Areafix < Formula
  desc "FTN areafix library"
  homepage "https://github.com/huskyproject/areafix"
  head "https://github.com/huskyproject/areafix.git"

  depends_on "fidoconf"

  patch :DATA
  def install
    inreplace "Makefile", "../huskymak.cfg", "huskymak.cfg"
    system "make"    
    lib.install Dir["libareafix.*"]
    include.install "areafix"
  end
end

__END__
--- areafix.orig/Makefile	2018-07-12 03:00:46.000000000 +0200
+++ areafix/Makefile	2018-07-12 03:02:07.000000000 +0200
@@ -58,9 +58,10 @@
 	$(LD) $(LFLAGS) -o $(TARGETDLL).$(VER) $(OBJS) $(LIBS)
   else
 $(TARGETDLL).$(VER): $(OBJS)
-	$(CC) $(LFLAGS) -shared -Wl,-soname,$(TARGETDLL).$(VERH) \
-          -o $(TARGETDLL).$(VER) $(OBJS) $(LIBS)
+	$(CC) $(LFLAGS) -shared -o $(TARGETDLL).$(VER) $(OBJS) $(LIBS)
   endif
+	$(LN) $(LNOPT) $(TARGETDLL).$(VER) $(TARGETDLL).$(VERH) ;\
+	$(LN) $(LNOPT) $(TARGETDLL).$(VER) $(TARGETDLL)

 instdyn: $(TARGETLIB) $(TARGETDLL).$(VER)
 	-$(MKDIR) $(MKDIROPT) $(DESTDIR)$(LIBDIR)
--- areafix.orig/huskymak.cfg	2018-07-11 22:53:55.000000000 +0200
+++ areafix/huskymak.cfg	2018-07-12 00:01:17.000000000 +0200
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
