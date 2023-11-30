##
#  Rules for GNU tools
##


#  See toolset.mk for documentation on which definitions are required and
#  their intended use.
#
B_CC=$(CC)
B_LIB=$(AR) rcsD
B_LIBOUT=
B_OBJEXT ?= o
B_LIBEXT ?= a
B_CINCCMD = -I
B_CFLAGS += $(CFLAGS)
B_CFLAGS +=-Wall $(P_CFLAGS)
#ifneq ($(B_DEBUG),0)
#B_CFLAGS +=-g -O0
#else
#B_CFLAGS +=-O
#endif
B_LDCMD=$(B_CC) $(B_CFLAGS) $(LDFLAGS) $^ -o $@
B_CLEANEXTRA=


#  See toolset.mk for documentation on which rules are required and their
#  intended use.
#
%.$(B_OBJEXT): %.c
	$(B_CC) $(B_CFLAGS) $(INCLUDES) -x c -c $< -o $@
