ldap(LDX) :-
    l_init(LDX), 
    l_bind(LDX),
    g_assign(ldx, LDX).


% RES       msg_id interno ao LDAP (int)
% MSG_ID    indice no vector ldap_messages[] (int) - relativo ao result
% COUNT     numero de registos encontrados que respeitam o filtro/criterio (int)

search(RES, MSG_ID, COUNT) :-
    g_read(ldx, LDX),
    l_search(LDX, 'dc=di,dc=uevora,dc=pt', 2, 'objectclass=*', [cn,objectclass], 0, RES),
    l_result(LDX, RES, 1, 0, _, MSG_ID),
    l_count_entries(LDX, MSG_ID, COUNT).

% l_entry recebe LDX, MSG_ID e devolve MSG_OUT
% MSG_OUT   indice no vector ldap_messages[] (int) - relativo à entry

% l_attribute recebe LDX, MSG_OUT e devolve ATTR (string)

% l_values recebe LDX, MSG_OUT, ATTR, BIN (int) e devolve VALUES (list)

