/* $Id$ */

/*
$Log$
Revision 1.1  2004/11/17 10:35:01  gjm
Initial revision

Revision 1.1.1.1  2004/11/03 11:42:49  pp
Initial CX version.


Revision 1.4  2001/06/13 02:07:33  pedro
*** empty log message ***

Revision 1.3  2001/06/10 03:02:24  pedro
*** empty log message ***

Revision 1.2  2001/06/10 01:52:14  pedro
*** empty log message ***

Revision 1.1  2001/06/10 00:39:36  pedro
Inclusão no CVS

*/

/*
 * pl_exceptions.h - macros para lançar excepções no Prolog quando acontecem
 *                   erros do lado LDAP
 *
 */

#ifndef PL_EXCEPTIONS_H_
#define PL_EXCEPTIONS_H_

#define Proldap_err(X)    Pl_Err_System(Create_Atom(X))


#define Proldap_err_maxconnections() Pl_Err_System(Create_Atom("Too many LDAP connections in use"))

#define Proldap_err_connect() Pl_Err_System(Create_Atom("Not connected to server"))

#define Proldap_err_search() Pl_Err_System(Create_Atom("Couldn't search"))

#define Proldap_err_result() Pl_Err_System(Create_Atom("Couldn't get result of previous LDAP operation"))

#define Proldap_err_timeout() Pl_Err_System(Create_Atom("Timeout while waiting for LDAP operation result"))

#define Proldap_err_maxmessages() Pl_Err_System(Create_Atom("Too many LDAP messages in use"))

#define Proldap_err_message() Pl_Err_System(Create_Atom("Invalid LDAP message ID"))

#define Proldap_err_attribute() Pl_Err_System(Create_Atom("Illegal attribute"));
//"Can't allocate LDAP connection handle"))


#endif

