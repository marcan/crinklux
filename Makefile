
TARGET = demo

SOURCES = functions.c main.c
SOURCES_REL = start.S symbols.S
SOURCES_DBG = start.S symbols.dbg.S
HEADERS = gl.h glu.h glut.h

GCCFLAGS = -m32
CFLAGS = -Os -Wall -fomit-frame-pointer -fno-stack-protector -fno-builtin-printf -fno-builtin-puts -fno-pic -ffast-math -fwhole-program -march=pentium4
LDFLAGS = -nostartfiles -nostdlib 
DBGFLAGS = -ldl -Wl,-T,debug.ld
MINIFLAGS = -Wl,-T,minimal.ld,-z,noexecstack

all : $(TARGET) $(TARGET).debug

$(TARGET) : $(TARGET).clean hdr
	xz --format=lzma --lzma1=preset=9e,lc=1,lp=0,pb=0 -c - < $(TARGET).clean > $(TARGET).lzma
	echo >> $(TARGET).lzma
	cat hdr > $(TARGET)
	tac < $(TARGET).lzma >> $(TARGET)
	chmod +x $(TARGET)

$(TARGET).clean : $(TARGET).raw.elf
	objcopy -O binary $< $@
	[ -e /usr/sbin/paxctl-ng ] && /usr/sbin/paxctl-ng -lpemrs $@

$(TARGET).raw.elf : $(SOURCES_REL) Makefile minimal.ld $(HEADERS)
	cat $(SOURCES) | gcc $(GCCFLAGS) -o $@ $(SOURCES_REL) $(CFLAGS) $(LDFLAGS) $(MINIFLAGS) -xc -

$(TARGET).debug : $(SOURCES_DBG) Makefile debug.ld $(HEADERS)
	cat $(SOURCES) | gcc $(GCCFLAGS) -o $@ -DDEBUG $(SOURCES_DBG) $(CFLAGS) $(LDFLAGS) $(DBGFLAGS) -xc -

symbols.S : symbols.txt symproc.py Makefile
	python symproc.py symbols.txt > symbols.S
symbols.dbg.S : symbols.txt symproc.py Makefile
	python symproc.py -d symbols.txt > symbols.dbg.S

clean:
	rm -f *.o $(TARGET).raw.elf $(TARGET).clean $(TARGET) $(TARGET).debug *.lzma *.bz2 symbols.S symbols.dbg.S
