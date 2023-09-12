B_OBJEXT ?= to

P_CFLAGS +=-Werror
#P_CFLAGS += -D_FILE_OFFSET_BITS=64 -D_XOPEN_SOURCE=500 -D_POSIX_C_SOURCE=200809

# Don't build redfuse by default since it relies on libfuse-dev,
# but do build redfuse if "make all" is explicitly run.

.PHONY: default
default: redfmt redimgbld

.PHONY: all
all: default redfuse

# The redconf.h for the tools #includes the redconf.h from the parent project
# to inherit its settings, so add it as a dependency.
REDPROJHDR=$(P_CONFDIR)/redconf.h

include $(P_BASEDIR)/build/hostos.mk
include $(P_BASEDIR)/build/toolset.mk
include $(P_BASEDIR)/build/reliance.mk

INCLUDES+=$(REDDRIVINC)

# FUSE driver reimplements the UID/GID OS service in fuse.c.
REDFUSEDRIVOBJ := $(subst $(P_BASEDIR)/os/$(P_OS)/services/osuidgid.$(B_OBJEXT),,$(REDDRIVOBJ))

TOOLHDR=\
	$(P_BASEDIR)/include/redtools.h
IMGBLDOBJ=\
	$(P_BASEDIR)/tools/imgbld/ibfse.$(B_OBJEXT) \
	$(P_BASEDIR)/tools/imgbld/ibposix.$(B_OBJEXT) \
	$(P_BASEDIR)/tools/imgbld/imgbld.$(B_OBJEXT) \
	$(P_BASEDIR)/os/$(P_OS)/tools/imgbldlinux.$(B_OBJEXT) \
	$(P_BASEDIR)/os/$(P_OS)/tools/imgbld_main.$(B_OBJEXT)
REDPROJOBJ=\
	$(IMGBLDOBJ) \
	$(P_BASEDIR)/os/$(P_OS)/tools/$(REDTOOLPREFIX)chk.$(B_OBJEXT) \
	$(P_BASEDIR)/os/$(P_OS)/tools/$(REDTOOLPREFIX)fmt.$(B_OBJEXT)


$(P_BASEDIR)/tools/imgbld/ibcommon.$(B_OBJEXT):		$(P_BASEDIR)/tools/imgbld/ibcommon.c $(REDHDR) $(TOOLHDR)
$(P_BASEDIR)/tools/imgbld/ibfse.$(B_OBJEXT):		$(P_BASEDIR)/tools/imgbld/ibfse.c $(REDHDR) $(TOOLHDR)
$(P_BASEDIR)/tools/imgbld/ibposix.$(B_OBJEXT):		$(P_BASEDIR)/tools/imgbld/ibposix.c $(REDHDR) $(TOOLHDR)
$(P_BASEDIR)/tools/imgbld.$(B_OBJEXT):			$(P_BASEDIR)/tools/imgbld/imgbld.c $(REDHDR) $(TOOLHDR)
$(P_BASEDIR)/os/$(P_OS)/tools/imgbldlinux.$(B_OBJEXT):	$(P_BASEDIR)/os/$(P_OS)/tools/imgbldlinux.c $(REDHDR) $(TOOLHDR)
$(P_BASEDIR)/os/$(P_OS)/tools/imgbld_main.$(B_OBJEXT):	$(P_BASEDIR)/os/$(P_OS)/tools/imgbld_main.c $(REDHDR) $(TOOLHDR)
$(P_BASEDIR)/os/$(P_OS)/tools/fuse.$(B_OBJEXT):		$(P_BASEDIR)/os/$(P_OS)/tools/fuse.c $(REDHDR) $(TOOLHDR)

# The redconf.c for the tools #includes the redconf.c from the parent project
# to inherit its settings, so add it as a dependency.
$(P_PROJDIR)/redconf.$(B_OBJEXT):	$(P_CONFDIR)/redconf.c

LIBNAME=libred.so
SONAME=$(LIBNAME).1
LIBRED=$(SONAME).0.0

$(LIBRED): $(REDDRIVOBJ) $(REDTOOLOBJ)
	$(B_CC) $(B_CFLAGS) $(LDFLAGS) -shared -Wl,-soname=$(SONAME) $^ -o $@

redfmt: $(P_BASEDIR)/os/$(P_OS)/tools/$(REDTOOLPREFIX)fmt.$(B_OBJEXT) $(LIBRED)
	$(B_LDCMD)

redimgbld: $(IMGBLDOBJ) $(LIBRED)
	$(B_LDCMD)

redfuse: $(P_BASEDIR)/os/$(P_OS)/tools/fuse.$(B_OBJEXT) $(LIBRED)
	$(B_CC) $^ $(LDFLAGS) $(LIBS) -o $@

.PHONY: clean
clean:
	$(B_DEL) $(REDDRIVOBJ) $(REDTOOLOBJ) $(REDPROJOBJ)
	$(B_DEL) $(P_BASEDIR)/os/$(P_OS)/tools/*.$(B_OBJEXT)
	$(B_DEL) $(P_BASEDIR)/tools/*.$(B_OBJEXT)
	$(B_DEL) redfmt redimgbld redfuse libred.so

$(REDDRIVOBJ) $(REDTOOLOBJ): %.$(B_OBJEXT): %.c
	$(B_CC) -fPIC $(B_CFLAGS) $(INCLUDES) -x c -c $< -o $@
