VERSION = 0.1

#install path
PREFIX = /usr
MANPREFIX = ${PREFIX}/share/man

# flags
CFLAGS = -pedantic -Wall -Wno-deprecated-declarations -std=c99 -g

# includes
INCLUDES = -lm

#compiler and linker
CC = clang
