# $Id$

# Makefile for gprolog-ldap-cx


TARGET = gprolog-ldap-cx


#---------------------------------------------------------------------------
# Dependencies for gprolog-ldap.
#---------------------------------------------------------------------------

GPROLOG-LDAP-INPUTS  = /gprolog-ldap.c            \
                       /gprolog-ldap-prolog.pl
GPROLOG-LDAP-INPUTS0 = $(subst /,gprolog-ldap/,$(GPROLOG-LDAP-INPUTS))
GPROLOG-LDAP-OBJECTS = $(subst .c,.o,$(subst .pl,.o,$(GPROLOG-LDAP-INPUTS0)))


#---------------------------------------------------------------------------
# Dependencies for ldap-cx.
#---------------------------------------------------------------------------

LDAP-CX-INPUTS  = /ldap.pl        \
                  /search.pl      \
                  /result.pl      \
                  /add.pl         \
                  /delete.pl      \
                  /modify.pl      \
                  /utils.pl
LDAP-CX-INPUTS0 = $(subst /,ldap-cx/,$(LDAP-CX-INPUTS))
LDAP-CX-OBJECTS = $(subst .c,.o,$(subst .pl,.o,$(LDAP-CX-INPUTS0)))



CCOPTS = -g -DDEBUG
LIBS   = -lldap
GPLC   = gplc-cx



all: $(TARGET)

$(TARGET): $(GPROLOG-LDAP-OBJECTS) $(LDAP-CX-OBJECTS)
	$(GPLC) -L '$(LIBS)' -o $@ $^ 


%.o: %.pl
	$(GPLC) -c $<

%.o: %.c
	$(GPLC) -C '$(CCOPTS)' -c $<



#---------------------------------------------------------------------------
# Cleanup.
#---------------------------------------------------------------------------

clean:
	find -name \*.o | xargs rm -f
	find -name \*~  | xargs rm -f

distclean: clean
	rm -f $(TARGET)




.PHONY: clean distclean



# $Log$
# Revision 1.5  2005/03/04 15:57:03  gjm
# *** empty log message ***
#
# Revision 1.4  2004/12/06 12:12:46  gjm
# *** empty log message ***
#
# Revision 1.3  2004/11/18 16:37:20  gjm
# Added search_2.pl to ldap-cx inputs.
#
# Revision 1.2  2004/11/18 16:08:12  gjm
# Final (?!) version.
#
# Revision 1.1.1.1  2004/11/17 10:35:01  gjm
# Initial revision.
#
