% $Id$

:- unit(ldap_result(RESULT)).


item(ATTRIBUTE, VALUE) :- value(ATTRIBUTE, VALUE).


%%---------------------------------------------------------------------------
%% Instantiates VALUE with ATTRIBUTE's value(s).
%%---------------------------------------------------------------------------

value(ATTRIBUTE, VALUE) :-
        ldx(LDX),
        ldap_values(LDX, RESULT, ATTRIBUTE, 0, VALUES),
        member(VALUE, VALUES).



%%---------------------------------------------------------------------------
%% Unifies ATTRIBUTE with search result's atributes.
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



%%---------------------------------------------------------------------------
%% Unifies DN with the result's DN.
%%---------------------------------------------------------------------------

dn(DN) :-
        ldx(LDX),
        ldap_dn(LDX, RESULT, DN).



%%---------------------------------------------------------------------------
%% Result ID.
%%---------------------------------------------------------------------------

result(RESULT).



%---------------------------------------------------------------------------
% $Log$
% Revision 1.2  2004/11/18 16:36:44  gjm
% *** empty log message ***
%
% Revision 1.1.1.1  2004/11/17 10:35:01  gjm
% Initial revision.
%

