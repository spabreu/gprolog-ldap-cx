% $Id$

:- unit(ldap(LDX)).


%%---------------------------------------------------------------------------
%% LDAP link. If not instantiated, tries to connect using default
%% parameters.
%%---------------------------------------------------------------------------

ldx(LDX) :- nonvar(LDX), !.
ldx(LDX) :- connect.



%%---------------------------------------------------------------------------
%% Initializes the LDAP library and opens a connection to an LDAP
%% server.
%%---------------------------------------------------------------------------

connect :- connect([]).

connect(OPTIONS) :-
        member_default(OPTIONS, host,     HOST,     'localhost'),
        member_default(OPTIONS, port,     PORT,     389),
        member_default(OPTIONS, dn,       DN,       ''),
        member_default(OPTIONS, password, PASSWORD, ''),

        ldap_init(HOST, PORT, LDX),
        ldap_bind(LDX, DN, PASSWORD).



%---------------------------------------------------------------------------
% $Log$
% Revision 1.2  2004/11/18 15:53:02  gjm
% *** empty log message ***
%
% Revision 1.1.1.1  2004/11/17 10:35:01  gjm
% Initial revision.
%

