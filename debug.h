#ifndef DEBUG_H
#define DEBUG_H

#include "demo.h"

#ifdef DEBUG
#define dbgprintf printf
int FWRAP(printf) (const char *fmt, ...);
#else
#define dbgprintf(...)
#endif

#endif
