% $Id$

ldap(LDX) :-
    l_init('127.0.0.1',LDX), 
    l_bind(LDX),
    g_assign(ldx, LDX).


% RES       msg_id interno ao LDAP (int)
% MSG_ID    indice no vector ldap_messages[] (int) - relativo ao result
% COUNT     numero de registos encontrados que respeitam o filtro/criterio (int)

search(RES, MSG_ID, COUNT) :-
    g_read(ldx, LDX),
    l_search(LDX, 'dc=di,dc=uevora,dc=pt', 2, 'objectclass=*', [], 0, RES),
    l_result(LDX, RES, 1, 0, _, MSG_ID),
    l_count_entries(LDX, MSG_ID, COUNT).

% l_entry recebe LDX, MSG_ID e devolve MSG_OUT
% MSG_OUT   indice no vector ldap_messages[] (int) - relativo à entry

% l_attribute recebe LDX, MSG_OUT e devolve ATTR (string)

% l_values recebe LDX, MSG_OUT, ATTR, BIN (int) e devolve VALUES (list)


get(MSG_ID, DN, ATTR, VALUES) :- 
    g_read(ldx, LDX), !,
    l_entry(LDX, MSG_ID),
    l_attribute(LDX, MSG_ID, ATTR),
    l_values(LDX, MSG_ID, ATTR, 0, VALUES),
    l_dn(LDX, MSG_ID, DN).

% escrever na linha do interpretador:
% ldap(X), search(RES, ID, COUNT), !, get(ID, DN, ATTR, VALUES).
