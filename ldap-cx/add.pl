% $Id$

:- unit(ldap_add(DN, ATTRS)).


%%---------------------------------------------------------------------------
%% Adds an object to an LDAP repository.
%%---------------------------------------------------------------------------

item :- add.

add :-
        ldx(LDX),
        ldap_add(LDX, DN, ATTRS).



%---------------------------------------------------------------------------
% $Log$
% Revision 1.1  2004/11/18 15:38:26  gjm
% Initial revision.
%

