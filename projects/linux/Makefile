#
# makefile for Linux project in Reliance Edge
#
GCCBIN="C:/arm-gnu-toolchain-12.2.rel1-mingw-w64-i686-arm-none-linux-gnueabihf/bin"
CROSS_COMPILE = $(GCCBIN)/arm-none-linux-gnueabihf-
B_HOSTOS=linux
P_PROJDIR := $(shell busybox.exe pwd)
P_BASEDIR := $(shell busybox.exe readlink -f $(P_PROJDIR)/../..)

P_PROJDIR ?= $(shell pwd)
P_BASEDIR ?= $(shell readlink -f $(P_PROJDIR)/../..)

B_DEBUG = 0
#B_DEBUG ?= 1

P_CFLAGS +=-Werror
ifneq ($(B_DEBUG),0)
P_CFLAGS +=-DDEBUG
else
P_CFLAGS +=-O
endif

.PHONY: all
all: fsstress

include $(P_BASEDIR)/build/hostos.mk
include $(P_BASEDIR)/build/toolset.mk
include $(P_BASEDIR)/build/reliance.mk

INCLUDES=$(REDALLINC)

REDPROJOBJ=\
	$(P_PROJDIR)/fsstress_main.$(B_OBJEXT)

$(P_PROJDIR)/fsstress_main.$(B_OBJEXT):		$(P_PROJDIR)/fsstress_main.c $(REDHDR)

fsstress: $(P_PROJDIR)/fsstress_main.$(B_OBJEXT) $(REDTESTOBJ)
	$(B_LDCMD) -Lhost -lred

.PHONY: clean
clean:
	$(B_DEL) $(REDALLOBJ) $(REDPROJOBJ)
	$(B_DEL) $(P_PROJDIR)/*.$(B_OBJEXT)
	$(B_DEL) fsstress
