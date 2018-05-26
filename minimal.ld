OUTPUT_FORMAT("elf32-i386", "elf32-i386",
              "elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(_start)
SEARCH_DIR("/usr/i386-pc-linux-gnu/lib32"); SEARCH_DIR("/usr/lib64/binutils/x86_64-pc-linux-gnu/2.1832"); SEARCH_DIR("/usr/local/lib32"); SEARCH_DIR("/lib32"); SEARCH_DIR("/usr/lib32"); SEARCH_DIR("/usr/i386-pc-linux-gnu/lib"); SEARCH_DIR("/usr/lib64/binutils/x86_64-pc-linux-gnu/2.18"); SEARCH_DIR("/usr/local/lib"); SEARCH_DIR("/lib"); SEARCH_DIR("/usr/lib");

SECTIONS
{
    PROVIDE (__executable_start = 0x08000000); . = 0x08000000;
    _base = .;
	.elfhdr :
	{
		_elfhdr = .;
		LONG(0x464c457f);
		LONG(0x00010101);
		/* yes these are my symbols in the middle of the ELF header, so sue me */
		PROVIDE(dlopen = .);
		LONG(0x00000000);
		PROVIDE(dlsym = .);
		LONG(0x00000000);
		SHORT(2);
		SHORT(3);
		LONG(1);
		LONG(_start);
		LONG(_phdr - _base);
		LONG(0);
		LONG(0);
		SHORT(_ehend - _elfhdr);
		SHORT(0x20);
		SHORT((_phend - _phdr)>>5);
		SHORT(0);
		/*SHORT(0);
		SHORT(0);*/
		_phdr = .;
		
		/* text */
		LONG(1);
		_ehend = .; /* hacky overlap */
		LONG(_text - _base);
		LONG(_text);
		LONG(_text);
		LONG(_data_end - _text);
		LONG(_bss_end - _text);
		LONG(7);
		LONG(4);
		
		/* interpreter */
		LONG(3);
		LONG(_interp - _base);
		LONG(_interp);
		LONG(_interp);
		LONG(_interp_end - _interp);
		LONG(_interp_end - _interp);
		LONG(4);
		LONG(1);
		
		/* dynamic */
		LONG(2);
		LONG(_dynamic - _base);
		LONG(_dynamic);
		LONG(_dynamic);
		LONG(_dynamic_end - _dynamic);
		LONG(_dynamic_end - _dynamic);
		LONG(6);
		LONG(4);

		_phend = .;
		
		_dynamic = .;
		LONG(0x01); LONG(_s_libdl - _string);
		LONG(0x05); LONG(_string);
		LONG(0x06); LONG(_symbol);
		LONG(0x0a); LONG(_string_end - _string);
		/*LONG(0x0b); LONG(0x10);*/ /* doesn't seem to be required */
		LONG(0x11); LONG(_rel);
		LONG(0x12); LONG(_rel_end - _rel);
		LONG(0x13); LONG(8);
		LONG(0x00); /* LONG(0); not needed */
		_dynamic_end = .;
		
		_text = .;
		_symbol = .;
		/* Undefined */
		/* abuse this for the relocation table */
		_rel = .;
		LONG(dlopen);
		LONG(0x106);
		LONG(dlsym);
		LONG(0x206);
		_rel_end = .;
		/* dlopen */
		LONG(_s_dlopen - _string);
		LONG(0);
		LONG(4);
		BYTE(0x12);
		BYTE(0);
		SHORT(0);
		/* dlsym */
		LONG(_s_dlsym - _string);
		LONG(0);
		LONG(4);
		BYTE(0x12);
		BYTE(0);
		SHORT(0);
		_symbol_end = .;

		_interp = .;
		BYTE(0x2F); BYTE(0x6C); BYTE(0x69); BYTE(0x62);
		BYTE(0x2F); BYTE(0x6C); BYTE(0x64); BYTE(0x2D);
		BYTE(0x6C); BYTE(0x69); BYTE(0x6E); BYTE(0x75);
		BYTE(0x78); BYTE(0x2E); BYTE(0x73); BYTE(0x6F);
		BYTE(0x2E); BYTE(0x32); BYTE(0x00);
		_interp_end = .;
		
		_string = .;
		_s_libdl = .;
		BYTE(0x6C); BYTE(0x69); BYTE(0x62); BYTE(0x64);
		BYTE(0x6C); BYTE(0x2E); BYTE(0x73); BYTE(0x6F);
		BYTE(0x2E); BYTE(0x32); BYTE(0x00);
		_s_dlopen = .;
		BYTE(0x64); BYTE(0x6C); BYTE(0x6F); BYTE(0x70);
		BYTE(0x65); BYTE(0x6E); BYTE(0x00);
		_s_dlsym = .;
		BYTE(0x64); BYTE(0x6C); BYTE(0x73); BYTE(0x79);
		BYTE(0x6D); BYTE(0x00);
		_string_end = .;
		
	}
  /DISCARD/       : { *(.interp) }
  /DISCARD/       : { *(.note.gnu.build-id) }
  /DISCARD/       : { *(.hash) }
  /DISCARD/       : { *(.gnu.hash) }
  /DISCARD/       : { *(.dynsym) }
  /DISCARD/       : { *(.dynstr) }
  /DISCARD/       : { *(.gnu.version) }
  /DISCARD/       : { *(.gnu.version_d) }
  /DISCARD/       : { *(.gnu.version_r) }
  .dlmeta         : { *(.dlmeta) }
  /DISCARD/       : { *(.dynamic) }
  /DISCARD/       :
    {
      *(.rel.init)
      *(.rel.text .rel.text.* .rel.gnu.linkonce.t.*)
      *(.rel.fini)
      *(.rel.rodata .rel.rodata.* .rel.gnu.linkonce.r.*)
      *(.rel.data.rel.ro* .rel.gnu.linkonce.d.rel.ro.*)
      *(.rel.data .rel.data.* .rel.gnu.linkonce.d.*)
      *(.rel.tdata .rel.tdata.* .rel.gnu.linkonce.td.*)
      *(.rel.tbss .rel.tbss.* .rel.gnu.linkonce.tb.*)
      *(.rel.ctors)
      *(.rel.dtors)
      *(.rel.got)
      *(.rel.bss .rel.bss.* .rel.gnu.linkonce.b.*)
    }
  .rela.dyn       :
    {
      *(.rela.init)
      *(.rela.text .rela.text.* .rela.gnu.linkonce.t.*)
      *(.rela.fini)
      *(.rela.rodata .rela.rodata.* .rela.gnu.linkonce.r.*)
      *(.rela.data .rela.data.* .rela.gnu.linkonce.d.*)
      *(.rela.tdata .rela.tdata.* .rela.gnu.linkonce.td.*)
      *(.rela.tbss .rela.tbss.* .rela.gnu.linkonce.tb.*)
      *(.rela.ctors)
      *(.rela.dtors)
      *(.rela.got)
      *(.rela.bss .rela.bss.* .rela.gnu.linkonce.b.*)
    }
  .rel.plt        : { *(.rel.plt) }
  .rela.plt       : { *(.rela.plt) }
  .plt            : { *(.plt) }
  .text           :
  {
    *(.text .stub .text.* .gnu.linkonce.t.*)
    KEEP (*(.text.*personality*))
    /* .gnu.warning sections are handled specially by elf32.em.  */
    *(.gnu.warning)
  } =0x00000000
  PROVIDE (__etext = .);
  PROVIDE (_etext = .);
  PROVIDE (etext = .);
  _text_end = .;
  _data = .;
  .rodata         : { *(.rodata .rodata.* .gnu.linkonce.r.*) }
  .rodata1        : { *(.rodata1) }
  /DISCARD/       : { *(.eh_frame_hdr) }
  /DISCARD/       : ONLY_IF_RO { KEEP (*(.eh_frame)) }
  /* Adjust the address for the data segment.  We want to adjust up to
     the same address within the page on the next page up.  */
  /* Thread Local Storage sections  */
  .tdata          : { *(.tdata .tdata.* .gnu.linkonce.td.*) }
  .tbss           : { *(.tbss .tbss.* .gnu.linkonce.tb.*) *(.tcommon) }
  .preinit_array     :
  {
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array))
    PROVIDE_HIDDEN (__preinit_array_end = .);
  }
  .init_array     :
  {
     PROVIDE_HIDDEN (__init_array_start = .);
     KEEP (*(SORT(.init_array.*)))
     KEEP (*(.init_array))
     PROVIDE_HIDDEN (__init_array_end = .);
  }
  .fini_array     :
  {
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(.fini_array))
    KEEP (*(SORT(.fini_array.*)))
    PROVIDE_HIDDEN (__fini_array_end = .);
  }
  .ctors          :
  {
    /* gcc uses crtbegin.o to find the start of
       the constructors, so we make sure it is
       first.  Because this is a wildcard, it
       doesn't matter if the user does not
       actually link against crtbegin.o; the
       linker won't look for a file to match a
       wildcard.  The wildcard also means that it
       doesn't matter which directory crtbegin.o
       is in.  */
    KEEP (*crtbegin.o(.ctors))
    KEEP (*crtbegin?.o(.ctors))
    /* We don't want to include the .ctor section from
       the crtend.o file until after the sorted ctors.
       The .ctor section from the crtend file contains the
       end of ctors marker and it must be last */
    KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .ctors))
    KEEP (*(SORT(.ctors.*)))
    KEEP (*(.ctors))
  }
  .dtors          :
  {
    KEEP (*crtbegin.o(.dtors))
    KEEP (*crtbegin?.o(.dtors))
    KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .dtors))
    KEEP (*(SORT(.dtors.*)))
    KEEP (*(.dtors))
  }
  .jcr            : { KEEP (*(.jcr)) }
  .data.rel.ro : { *(.data.rel.ro.local* .gnu.linkonce.d.rel.ro.local.*) *(.data.rel.ro* .gnu.linkonce.d.rel.ro.*) }
  .dynamic        : { *(.dynamic) }
  .got            : { *(.got) }
  .got.plt        : { *(.got.plt) }
  .data           :
  {
    *(.data .data.* .gnu.linkonce.d.*)
    KEEP (*(.gnu.linkonce.d.*personality*))
    SORT(CONSTRUCTORS)
  }
  .data1          : { *(.data1) }
  _edata = .; PROVIDE (edata = .);
  _data_end = .;
  __bss_start = .;
  .bss.dlsyms : {
    *(.bss.dlsyms)
  }
  .bss            :
  {
   *(.dynbss)
   *(.bss .bss.* .gnu.linkonce.b.*)
   *(COMMON)
   /* Align here to ensure that the .bss section occupies space up to
      _end.  Align after .bss to ensure correct alignment even if the
      .bss section disappears because there are no input sections.
      FIXME: Why do we need it? When there is no .bss section, we don't
      pad the .data section.  */
   . = ALIGN(. != 0 ? 32 / 8 : 1);
  }
  . = ALIGN(32 / 8);
  _bss_end = .;
  _end = .; PROVIDE (end = .);
  /* Stabs debugging sections.  */
  .stab          0 : { *(.stab) }
  .stabstr       0 : { *(.stabstr) }
  .stab.excl     0 : { *(.stab.excl) }
  .stab.exclstr  0 : { *(.stab.exclstr) }
  .stab.index    0 : { *(.stab.index) }
  .stab.indexstr 0 : { *(.stab.indexstr) }
  .comment       0 : { *(.comment) }
  /* DWARF debug sections.
     Symbols in the DWARF debugging sections are relative to the beginning
     of the section so we begin them at 0.  */
  /* DWARF 1 */
  .debug          0 : { *(.debug) }
  .line           0 : { *(.line) }
  /* GNU DWARF 1 extensions */
  .debug_srcinfo  0 : { *(.debug_srcinfo) }
  .debug_sfnames  0 : { *(.debug_sfnames) }
  /* DWARF 1.1 and DWARF 2 */
  .debug_aranges  0 : { *(.debug_aranges) }
  .debug_pubnames 0 : { *(.debug_pubnames) }
  /* DWARF 2 */
  .debug_info     0 : { *(.debug_info .gnu.linkonce.wi.*) }
  .debug_abbrev   0 : { *(.debug_abbrev) }
  .debug_line     0 : { *(.debug_line) }
  .debug_frame    0 : { *(.debug_frame) }
  .debug_str      0 : { *(.debug_str) }
  .debug_loc      0 : { *(.debug_loc) }
  .debug_macinfo  0 : { *(.debug_macinfo) }
  /* SGI/MIPS DWARF 2 extensions */
  .debug_weaknames 0 : { *(.debug_weaknames) }
  .debug_funcnames 0 : { *(.debug_funcnames) }
  .debug_typenames 0 : { *(.debug_typenames) }
  .debug_varnames  0 : { *(.debug_varnames) }
  /* DWARF 3 */
  .debug_pubtypes 0 : { *(.debug_pubtypes) }
  .debug_ranges   0 : { *(.debug_ranges) }
  .gnu.attributes 0 : { KEEP (*(.gnu.attributes)) }
  /DISCARD/ : { *(.note.GNU-stack) *(.gnu_debuglink) }
}


