% $Id$

:- unit(ldap_modify(DN, ATTRS)).

/*
 * ATTENTION: For each attribute specified in mods, modify will replace
 *            ALL existing attributes to the supplied value.
 *
 */
 

%%---------------------------------------------------------------------------
%% Modifies an object in an LDAP repository.
%%---------------------------------------------------------------------------

item :- modify.

modify :-
        ldx(LDX),
        ldap_modify(LDX, DN, ATTRS).


%---------------------------------------------------------------------------
% $Log$
% Revision 1.2  2004/12/06 12:14:15  gjm
% Limited working version.
%
% Revision 1.1  2004/11/18 15:56:14  gjm
% Initial revision.
%

