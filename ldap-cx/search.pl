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
        ldap_result(LDX, MSGID, 1, TIMEOUT, _, RES).


%---------------------------------------------------------------------------
% $Log$
% Revision 1.2  2004/12/06 12:16:21  gjm
% ldap_result/6 now retrieves all results from backend.
%
% Revision 1.1.1.1  2004/11/17 10:35:01  gjm
% Initial revision.
%

