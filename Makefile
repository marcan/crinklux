
TARGET = demo

OBJECTS = main.o functions.o symbols.o
OBJECTS_DBG = $(patsubst %.o,%.dbg.o,$(OBJECTS))

GCCFLAGS = -m32
CFLAGS = -Os -Wall -fno-stack-protector -fno-builtin-printf -fno-builtin-puts -fno-pic
LDFLAGS = -nostartfiles -nostdlib 
DBGFLAGS = -ldl -Wl,-T,debug.ld
MINIFLAGS = -Wl,-T,minimal.ld,-z,noexecstack
ASFLATS = 

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

$(TARGET).raw.elf : $(OBJECTS) start.o Makefile minimal.ld
	gcc $(GCCFLAGS) -o $@ $(OBJECTS) start.o $(LDFLAGS) $(MINIFLAGS)

$(TARGET).debug : $(OBJECTS_DBG) start.o Makefile debug.ld
	gcc $(GCCFLAGS) -o $@ $(OBJECTS_DBG) start.o $(LDFLAGS) $(DBGFLAGS)

symbols.S : symbols.txt symproc.py Makefile
	python symproc.py symbols.txt > symbols.S
symbols.dbg.S : symbols.txt symproc.py Makefile
	python symproc.py -d symbols.txt > symbols.dbg.S

%.dbg.o: %.c gl.h glu.h glut.h Makefile
	gcc -c -DDEBUG $(GCCFLAGS) $(CFLAGS) -o $@ $<

%.o: %.c gl.h glu.h glut.h Makefile
	gcc -c $(GCCFLAGS) $(CFLAGS) -o $@ $<

%.o: %.S Makefile
	gcc -c $(GCCFLAGS) -o $@ $< $(ASFLAGS)

clean:
	rm -f *.o $(TARGET).raw.elf $(TARGET).clean $(TARGET) $(TARGET).debug *.lzma *.bz2 symbols.S symbols.dbg.S
