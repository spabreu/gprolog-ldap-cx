% $Id$

:- unit(ldap_search(BASEDN, FILTER, OPTIONS)).


%%---------------------------------------------------------------------------
%% Performs an LDAP search operation.
%%---------------------------------------------------------------------------

item(RES) :- search(RES).

search(ldap_result(RES)) :-
        member_default(OPTIONS, attrs,   ATTRS,   []),
        member_default(OPTIONS, timeout, TIMEOUT, 0),
                       
        ldx(LDX),
        ldap_search(LDX, BASEDN, 2, FILTER, ATTRS, 0, MSGID),
        ldap_result(LDX, MSGID, 0, TIMEOUT, _, RES).


%---------------------------------------------------------------------------
% $Log$
% Revision 1.1  2004/11/17 10:35:01  gjm
% Initial revision
%

