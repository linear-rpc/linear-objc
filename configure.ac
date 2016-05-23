#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_INIT([linear-objc], [0.6.6], [https://github.com/linear-rpc/linear-objc])
AC_CONFIG_AUX_DIR(m4)
AC_CONFIG_MACRO_DIR(m4)
AC_CONFIG_SRCDIR([include/LinearClient.h])
AM_INIT_AUTOMAKE([foreign])
AC_CONFIG_HEADERS([config.h])

m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

# -fobjc-arc
#  enable to use ARC(Automatic Reference Counting)
# -fmessage-length
#  http://stackoverflow.com/questions/12015624/what-is-meanging-of-gcc-option-fmessage-length
# -fpascal-strings
#  Enable support for Pascal-style strings with	"\pfoo".
# -Wno-trigraphs
#  http://stackoverflow.com/questions/8435379/trigraph-ignored-use-trigraphs-to-enable
OBJCFLAGS="$OBJCFLAGS -fobjc-arc -fmessage-length=0 -fpascal-strings -Wno-trigraphs"
OBJCXXFLAGS="$OBJCXXFLAGS -fobjc-arc -fmessage-length=0 -fpascal-strings -Wno-trigraphs"

# Checks for programs.
AC_PROG_OBJC
AC_PROG_OBJCXX
AC_PROG_LIBTOOL

# TODO: add more warning options.
OBJCFLAGS="$OBJCFLAGS -Wall -Werror"
OBJCXXFLAGS="$OBJCXXFLAGS -Wall -Werror"

AC_ARG_WITH([ssl],
            [AC_HELP_STRING([--with-ssl], [supports SSL transport by using OpenSSL@<:@default=no@:>@])],
            [with_ssl=$withval], [with_ssl=no])
if test "x$with_ssl" = "xyes"; then
   OBJCFLAGS="$OBJCFLAGS -DWITH_SSL -I`pwd`/deps/OpenSSL-for-iPhone"
   OBJCXXFLAGS="$OBJCXXFLAGS -DWITH_SSL -I`pwd`/deps/OpenSSL-for-iPhone"
   LDFLAGS="$LDFLAGS -L`pwd`/deps/OpenSSL-for-iPhone/lib"
   LIBS="$LIBS -lcrypto -lssl"
elif test "x${with_ssl}" != "xno"; then
   OBJCFLAGS="$OBJCFLAGS -DWITH_SSL -I$with_ssl/include"
   OBJCXXFLAGS="$OBJCXXFLAGS -DWITH_SSL -I$with_ssl/include"
   LDFLAGS="$LDFLAGS -L$with_ssl/lib"
   LIBS="$LIBS -lcrypto -lssl"
fi
AM_CONDITIONAL([WITH_SSL], [test "x${with_ssl}" != "xno"])

AC_CONFIG_FILES([
        Makefile
        include/Makefile
        src/Makefile
        ])

AC_CONFIG_SUBDIRS(deps/linear-cpp)

AC_OUTPUT
