# $Id$

INPUTS  = $(shell find -name \*.pl | grep -v CVS)
OBJECTS = $(subst .c,.o,$(subst .pl,.o,$(INPUTS)))

include ../Defs.make


all: $(OBJECTS)


include ../Rules.make


# $Log$
# Revision 1.1  2004/11/17 10:35:01  gjm
# Initial revision
#
