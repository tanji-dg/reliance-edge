#
# Makefile for a Reliance Edge Linux host tools project
#
GCCBIN="C:/arm-gnu-toolchain-12.2.rel1-mingw-w64-i686-arm-none-linux-gnueabihf/bin"
CROSS_COMPILE = $(GCCBIN)/arm-none-linux-gnueabihf-
B_HOSTOS=linux
OS=linux
P_CFLAGS=-I ../../../../sfram_drv_test/DUKE_SDK/ag6r/linux/sysroot/usr/include
LDFLAGS=-L ../../../../sfram_drv_test/DUKE_SDK/ag6r/linux/sysroot/usr/lib
#LDFLAGS+=-s
#B_CFLAGS=-s
LDFLAGS+=-g
B_DEBUG = 1

P_BASEDIR ?= ../../..
P_PROJDIR ?= $(P_BASEDIR)/projects/linux/host
P_CONFDIR ?= $(P_PROJDIR)/..
B_DEBUG ?= 0

ifeq ($(OS),Windows_NT)
include $(P_BASEDIR)/os/win32/build/host.mk
else
include $(P_BASEDIR)/os/linux/build/host.mk
endif

