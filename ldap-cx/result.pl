% $Id$

:- unit(ldap_result(RESULT)).


item(VALUES) :-
        ldx(LDX),
        ldap_entry(LDX, RESULT),
        findall(A=Vs, ( attribute(A), values(A, Vs) ), VALUES).



%%---------------------------------------------------------------------------
%% Gets and attribute's value(s).
%%---------------------------------------------------------------------------

%% Instantiates VALUE with each of the attribute's values, through
%% backtracking.
value(ATTRIBUTE, VALUE) :-
        values(ATTRIBUTE, VALUES),
        member(VALUE, VALUES).


%% Instantiates VALUES with all of the attribute's values.
values(ATTRIBUTE, FVALUES) :-
        ldx(LDX),
        ldap_values(LDX, RESULT, ATTRIBUTE, 0, VALUES),
        fix_values(VALUES, FVALUES).


%% If VALUES is single element list, removes the list.
fix_values([V], V) :- !.
fix_values(Vs, Vs).



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
% Revision 1.3  2004/12/06 12:15:32  gjm
% item/1 instantiates, for each entry, with a list of attributes and
% respective values.
%
% Revision 1.2  2004/11/18 16:36:44  gjm
% *** empty log message ***
%
% Revision 1.1.1.1  2004/11/17 10:35:01  gjm
% Initial revision.
%

