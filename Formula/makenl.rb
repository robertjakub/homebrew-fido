class Makenl < Formula
  desc "Fidonet nodelist compiler"
  homepage "https://sourceforge.net/projects/makenl/"
  url "https://downloads.sourceforge.net/project/makenl/makenl/3.4.6/MN346SRC.ZIP"
  sha256 "73087b084b9eab430f52820ad983d43e30f7e9888d16dbca3841f52f0786a1fb"

  patch :p0, :DATA
  def install
    Dir.chdir('src')
    system "make", "-f", "makefile.osx"
    bin.install "makenl"
    man1.install "makenl.1"
  end
end

__END__
diff -Naur src.orig/config.c src/config.c
--- src.orig/config.c	2016-10-29 08:58:12.000000000 +0200
+++ src/config.c	2018-07-11 22:21:19.000000000 +0200
@@ -386,6 +386,7 @@
     {"LOGLEVEL", 4, CFG_LOGLEVEL},
     {"ALLOW8BIT", 6, CFG_ALLOW8BIT},
     {"REMOVEBOM", 3, CFG_REMOVEBOM},
+    {"FIXEOFCHAR", 3, CFG_REMOVEEOF},
     {NULL, 0, -1}
 };

@@ -470,7 +471,8 @@
   {2, 2},                        /* LOGLevel 1..4 - default 1 */
   {2, 2},                        /* FORcesubmit 1 or 0 - default 0 */
   {2, 2},                        /* ALLOW8BIT 1 or 0 - default 0 */
-  {2, 2}			 /* REMOVEBOM 1 or 0 - default 0 */
+  {2, 2},			 /* REMOVEBOM 1 or 0 - default 0 */
+  {2, 2}			 /* REMOVEEOF 1 or 0 - default 0 */
 };
 /* *INDENT-ON* */

@@ -760,6 +761,16 @@
                 mode = -1;
             }
             break;
+        case CFG_REMOVEEOF:
+            if (args[0][0] >= '0' && args[0][0] < '2' && args[0][1] == 0)
+                RemoveEOF = args[0][0] - '0';
+            else
+            {
+                mklog(LOG_ERROR, "FIXEOFCHAR argument '%s' must be 0 or 1",
+                    args[0]);
+                mode = -1;
+            }
+            break;
         case CFG_REMOVEBOM:
             if (args[0][0] >= '0' && args[0][0] < '2' && args[0][1] == 0)
                 RemoveBOM = args[0][0] - '0';
diff -Naur src.orig/config.h src/config.h
--- src.orig/config.h	2016-10-29 08:58:12.000000000 +0200
+++ src/config.h	2018-07-11 22:21:19.000000000 +0200
@@ -64,6 +64,9 @@
 /* Remove UTF-8 Byte Order Marks (BOM) */
 #define CFG_REMOVEBOM 40

+/* Remove EOF character */
+#define CFG_REMOVEEOF 42
+
 struct switchstruct
 {
     char *name;
diff -Naur src.orig/fts5.h src/fts5.h
--- src.orig/fts5.h	2016-10-29 08:58:12.000000000 +0200
+++ src/fts5.h	2018-07-11 22:21:19.000000000 +0200
@@ -42,6 +42,9 @@
 /* Remove UTF-8 Byte Order Marks (BOM) */
 extern int RemoveBOM;

+/* Remove EOF character */
+extern int RemoveEOF;
+
 extern char namebuf[16];
 extern const char *const LevelsSimple[];
 extern char *Levels[];
diff -Naur src.orig/makenl.c src/makenl.c
--- src.orig/makenl.c	2013-09-25 21:46:00.000000000 +0200
+++ src/makenl.c	2018-07-11 22:21:19.000000000 +0200
@@ -45,6 +45,8 @@

 int debug_mode = 0;

+int RemoveEOF = 0;
+
 int nl_baudrate[MAX_BAUDRATES];

 char *WorkFile = NULL;
@@ -260,7 +262,10 @@
     {
         CopyComment(OutFILE, EpilogFile, NULL, &OutCRC);
         OutCRC = CRC16DoByte(0, CRC16DoByte(0, OutCRC));
-        putc('\x1A', OutFILE);
+	if (RemoveEOF == 0)
+	{
+            putc('\x1A', OutFILE);
+        }
         fseek(OutFILE, 0L, SEEK_SET);
         fprintf(OutFILE, "%s%05u\r\n", HeaderLine, OutCRC);
         fclose(OutFILE);
diff -Naur src.orig/strtool.c src/strtool.c
--- src.orig/strtool.c	2013-09-25 21:39:07.000000000 +0200
+++ src/strtool.c	2018-07-11 22:14:35.000000000 +0200
@@ -80,6 +80,7 @@
     return orig;
 }

+#ifndef __APPLE__

 /*
  *  strlcpy() and strlcat()
@@ -144,3 +145,5 @@
     }
     return ret;
 }
+
+#endif
diff -Naur src.orig/strtool.h src/strtool.h
--- src.orig/strtool.h	2013-09-25 21:46:00.000000000 +0200
+++ src/strtool.h	2018-07-11 22:14:49.000000000 +0200
@@ -8,9 +8,13 @@
 char *cutspaces(char *string);
 char *strupper(char *string);

+#ifndef __APPLE__
+
 size_t strlcpy(char *d, const char *s, size_t bufsize);
 size_t strlcat(char *d, const char *s, size_t bufsize);

+#endif
+
 /* necessary for some C implementations where printf("%s\n", NULL) would cause a segfault */

 #define make_str_safe(x) (x)?(x):"(null)"
