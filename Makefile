# $Id$

# Makefile for gprolog-ldap-cx


TARGET = gprolog-ldap-cx


#---------------------------------------------------------------------------
# Dependencies for gprolog-ldap.
#---------------------------------------------------------------------------

GPROLOG-LDAP-INPUTS  = /gprolog-ldap.c                      \
                       /gprolog-ldap-prolog.pl
GPROLOG-LDAP-INPUTS0 = $(subst /,gprolog-ldap/,$(GPROLOG-LDAP-INPUTS))
GPROLOG-LDAP-OBJECTS = $(subst .c,.o,$(subst .pl,.o,$(GPROLOG-LDAP-INPUTS0)))


#---------------------------------------------------------------------------
# Dependencies for ldap-cx.
#---------------------------------------------------------------------------

LDAP-CX-INPUTS  = /ldap.pl                                  \
                  /search.pl                                \
                  /result.pl                                \
                  /utils.pl
LDAP-CX-INPUTS0 = $(subst /,ldap-cx/,$(LDAP-CX-INPUTS))
LDAP-CX-OBJECTS = $(subst .c,.o,$(subst .pl,.o,$(LDAP-CX-INPUTS0)))



CCOPTS = -C '-g -DDEBUG'
LIBS   = -L -lldap
GPLC   = gplc-cx



all: $(TARGET)

$(TARGET): $(GPROLOG-LDAP-OBJECTS) $(LDAP-CX-OBJECTS)
	$(GPLC) $(LIBS) -o $@ $^ 


%.o: %.pl
	$(GPLC) -c $<

%.o: %.c
	$(GPLC) $(CCOPTS) -c $<



#---------------------------------------------------------------------------
# Cleanup.
#---------------------------------------------------------------------------

.PHONY: clean distclean

clean:
	find -name \*.o | xargs rm -f
	find -name \*~  | xargs rm -f

distclean: clean
	rm -f $(TARGET)



# $Log$
# Revision 1.1  2004/11/17 10:35:01  gjm
# Initial revision
#
