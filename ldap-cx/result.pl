% $Id$

:- unit(ldap_result(RESULT)).



item(ATTRIBUTE, VALUE) :- value(ATTRIBUTE, VALUE).


value(ATTRIBUTE, VALUE) :-
        ldx(LDX),
        ldap_values(LDX, RESULT, ATTRIBUTE, 0, VALUES),
        member(VALUE, VALUES).



%%---------------------------------------------------------------------------
%% Unifies ATTRIBUTE with the atributes.
%%---------------------------------------------------------------------------

attribute(ATTRIBUTE) :-
        ldx(LDX),
        ldap_attribute(LDX, RESULT, ATTRIBUTE).



%%---------------------------------------------------------------------------
%% Count the number of entries in the result.
%%---------------------------------------------------------------------------

count(COUNT) :-
        ldx(LDX),
        ldap_count_entries(LDX, RESULT, COUNT).



dn(DN) :-
        ldx(LDX),
        ldap_dn(LDX, RESULT, DN).



%%---------------------------------------------------------------------------
%% Result ID.
%%---------------------------------------------------------------------------

result(RESULT).



%---------------------------------------------------------------------------
% $Log$
% Revision 1.1  2004/11/17 10:35:01  gjm
% Initial revision
%

