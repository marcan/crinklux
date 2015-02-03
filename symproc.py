#!/usr/bin/python

import os, sys

if sys.argv[1] == "-d":
	debug = False
	fin = open(sys.argv[2],"r")
else:
	debug = True
	fin = open(sys.argv[1],"r")

data = []
symbols = []

for l in fin:
	l = l.replace("\n","")
	if l == "":
		continue
	if l[0] == "#":
		continue
	op, arg = l.split(" ")
	if op == "LIB":
		data.append(arg)
	elif op == "SYMBOL":
		data.append(arg)
		symbols.append(arg)

if debug:
	symbols += ["printf", "puts"]
	data += ["libc.so.6", "printf", "puts"]

print '.section .bss.dlsyms,"a",@nobits'
print ".align 4"
print ".globl dlsyms"
print "dlsyms:"
for i in symbols:
	print ".globl %s" % i
	print ".type %s, @object" % i
	print ".size %s, 4" % i
	print "%s:" % i
	print ".zero 4"
print '.section .dlmeta,"a",@progbits'
print ".globl dlmeta"
print ".type dlmeta, @object"
print "dlmeta:"
for i in data:
	print ".string \"%s\"" % i.encode("string_escape")
print ".string \"\""
print ".size dlmeta, .-dlmeta"
