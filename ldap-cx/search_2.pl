% $Id$

:- unit(ldap_search(BASEDN, FILTER)).


%%---------------------------------------------------------------------------
%% Performs an LDAP search operation.
%%---------------------------------------------------------------------------

item(RES) :- search(RES).

search(RES) :- ldap_search(BASEDN, FILTER, []) :> search(RES).



%---------------------------------------------------------------------------
% $Log$
% Revision 1.1  2004/11/18 15:54:24  gjm
% Initial revision.
%

