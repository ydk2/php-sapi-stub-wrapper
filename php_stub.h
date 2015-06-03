/*
#if (defined(__APPLE__) && defined(__MACH__))
#define DARWIN
#endif
*/
#ifdef WIN32
#define PHP_STUB_WIN32_NO_CONSOLE 1
#define PATH_MAX MAX_PATH
#endif
#include <php.h>
#include <php_ini.h>
#include <SAPI.h>
#include <TSRM.h>
#include <zend.h>
#include <zend_ini.h>
#include <zend_execute.h>
#include <zend_exceptions.h>
#ifndef WIN32
#include <unistd.h>
#include <libgen.h>
#include <stdbool.h>
#include <stddef.h>
#endif
#include <stdio.h>


#if defined(DARWIN)
#import <crt_externs.h>
#endif


char* join(char *parent,char *add);