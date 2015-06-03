dnl
dnl $Id$
dnl

PHP_ARG_ENABLE(stub-wrapper,,
[  --enable-stub-wrapper           Building STUB application wrapper], no, no)

AC_MSG_CHECKING(for STUB build)
if test "$PHP_STUB" != "no"; then
  PHP_ADD_MAKEFILE_FRAGMENT($abs_srcdir/sapi/stub/Makefile.frag)

  dnl Set filename
  SAPI_STUB_PATH=sapi/stub/stub

  dnl Select SAPI
  PHP_SELECT_SAPI(stub, program, php_stub.c php_embed.c,, '$(SAPI_STUB_PATH)')

  case $host_alias in
  *aix*)
    if test "$php_sapi_module" = "shared"; then
      BUILD_STUB="echo '\#! .' > php.sym && echo >>php.sym && nm -BCpg \`echo \$(PHP_GLOBAL_OBJS) \$(PHP_BINARY_OBJS) \$(PHP_STUB_OBJS) | sed 's/\([A-Za-z0-9_]*\)\.lo/.libs\/\1.o/g'\` | \$(AWK) '{ if (((\$\$2 == \"T\") || (\$\$2 == \"D\") || (\$\$2 == \"B\")) && (substr(\$\$3,1,1) != \".\")) { print \$\$3 } }' | sort -u >> php.sym && \$(LIBTOOL) --mode=link \$(CC) -export-dynamic \$(CFLAGS_CLEAN) \$(EXTRA_CFLAGS) \$(EXTRA_LDFLAGS_PROGRAM) \$(LDFLAGS) -Wl,-brtl -Wl,-bE:php.sym \$(PHP_RPATHS) \$(PHP_GLOBAL_OBJS) \$(PHP_STUB_OBJS) \$(EXTRA_LIBS) \$(ZEND_EXTRA_LIBS) -o \$(SAPI_STUB_PATH)"
    else
      BUILD_STUB="echo '\#! .' > php.sym && echo >>php.sym && nm -BCpg \`echo \$(PHP_GLOBAL_OBJS) \$(PHP_BINARY_OBJS) \$(PHP_STUB_OBJS) | sed 's/\([A-Za-z0-9_]*\)\.lo/\1.o/g'\` | \$(AWK) '{ if (((\$\$2 == \"T\") || (\$\$2 == \"D\") || (\$\$2 == \"B\")) && (substr(\$\$3,1,1) != \".\")) { print \$\$3 } }' | sort -u >> php.sym && \$(LIBTOOL) --mode=link \$(CC) -export-dynamic \$(CFLAGS_CLEAN) \$(EXTRA_CFLAGS) \$(EXTRA_LDFLAGS_PROGRAM) \$(LDFLAGS) -Wl,-brtl -Wl,-bE:php.sym \$(PHP_RPATHS) \$(PHP_GLOBAL_OBJS) \$(PHP_STUB_OBJS) \$(EXTRA_LIBS) \$(ZEND_EXTRA_LIBS) -o \$(SAPI_STUB_PATH)"
    fi
    ;;
  *darwin*)
    BUILD_STUB="\$(CC) \$(CFLAGS_CLEAN) \$(EXTRA_CFLAGS) \$(EXTRA_LDFLAGS_PROGRAM) \$(LDFLAGS) \$(NATIVE_RPATHS) \$(PHP_GLOBAL_OBJS:.lo=.o) \$(PHP_BINARY_OBJS:.lo=.o) \$(PHP_STUB_OBJS:.lo=.o) \$(PHP_FRAMEWORKS) \$(EXTRA_LIBS) \$(ZEND_EXTRA_LIBS) -o \$(SAPI_STUB_PATH)"
    ;;
  *netware*)
    BUILD_STUB="\$(LIBTOOL) --mode=link \$(CC) -export-dynamic \$(CFLAGS_CLEAN) \$(EXTRA_CFLAGS) \$(EXTRA_LDFLAGS_PROGRAM) \$(LDFLAGS) \$(PHP_RPATHS) \$(PHP_BINARY_OBJS) \$(PHP_STUB_OBJS) \$(EXTRA_LIBS) \$(ZEND_EXTRA_LIBS) -Lnetware -lphp5lib -o \$(SAPI_STUB_PATH)"
    ;;
  *)
    BUILD_STUB="\$(LIBTOOL) --mode=link \$(CC) -export-dynamic \$(CFLAGS_CLEAN) \$(EXTRA_CFLAGS) \$(EXTRA_LDFLAGS_PROGRAM) \$(LDFLAGS) \$(PHP_RPATHS) \$(PHP_GLOBAL_OBJS) \$(PHP_BINARY_OBJS) \$(PHP_STUB_OBJS) \$(EXTRA_LIBS) \$(ZEND_EXTRA_LIBS) -o \$(SAPI_STUB_PATH)"
    ;;
  esac

  dnl Set executable for tests
  PHP_EXECUTABLE="\$(top_builddir)/\$(SAPI_STUB_PATH)"
  PHP_SUBST(PHP_EXECUTABLE)

  dnl Expose to Makefile
  PHP_SUBST(SAPI_STUB_PATH)
  PHP_SUBST(BUILD_STUB)

  PHP_OUTPUT(sapi/stub/stub.1)

fi
AC_MSG_RESULT($PHP_STUB)
