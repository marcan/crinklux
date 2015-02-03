#include "debug.h"

#define RTLD_NOW        0x00002 /* Immediate function call binding.  */

#ifdef DEBUG
extern void * dlopen(const char *filename, int flag);
extern void * dlsym(void *handle, const char *symbol);
#else
extern void * (*dlopen)(const char *filename, int flag);
extern void * (*dlsym)(void *handle, const char *symbol);
#endif

extern void *dlsyms[];
extern char dlmeta[];

#ifdef DEBUG
static void _puts(const char *s) {
	const char *p = s;
	while(*p) p++;
	asm ("int $0x80" :: "a"(4), "b"(1), "c"(s), "d"(p-s) );
}
static void _puth(unsigned int v) {
	char buf[9];
	int i;
	unsigned int j;
	for (i = 0; i < 8; i++) {
		j = (v >> (28 - 4*i)) & 0xf;
		buf[i] = j > 10 ? ('a'+j-10) : '0'+j;
	}
	buf[8] = 0;
	_puts(buf);
}
#else
#define _puts(...) do {} while(0)
#define _puth(...) do {} while(0)
#endif

void initFuncs(void)
{
	const char *p=dlmeta;
	void **pfn=dlsyms;
	void *handle=0, *tmp;
	while(*p)
	{
		_puts("--> ");
		_puts(p);
		tmp = dlopen(p, RTLD_NOW);
		if (!tmp)
		{
			_puts(" SYM ");
			*pfn=dlsym(handle, p);
			_puth((unsigned int)*pfn);
			_puts("\n");
			++pfn;
		}
		else
		{
			_puts(" LIB ");
			_puth((unsigned int)tmp);
			_puts("\n");
			handle=tmp;
		}
		while(*p++);
	}
	dbgprintf("initFuncs() done\n");
}

