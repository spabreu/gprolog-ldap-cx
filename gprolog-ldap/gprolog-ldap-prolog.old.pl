% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                    %
%       ProLDAP-cx - API em Prolog para LDAP         %
%                                                    %
%           ( parte II - API em Prolog )             %
%                                                    %
%             Pedro Patinho 2001-2004                %
%                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:- unit(ldap(LDX)).

%%%%
%%%
%%   FOREIGN DECLARATIONS (for internal use only...)
%

% l_init(+host, +port, -ldx)
:- foreign('_l_init'(+string, +positive, -integer),[fct_name(l_init)]).

% l_bind(+ldx, +dn, +password)
:- foreign('_l_bind'(+integer, +string, +string), [fct_name(l_bind)]).


% EXEMPLO:
% add(LDX, 'cn=xpto,dc=uevora,dc=pt',
%	dados( 
%	       cn(xpto), 
%	       objectclass(top, account, posixAccount, shadowAccount,
%			   uevoraEntity, uevoraPerson)
%	       ).
:- foreign('_l_add'(+integer, +string, +term), [fct_name(l_add)]).

:- foreign('_l_del'(+integer, +string), [fct_name(l_del)]).

:- foreign('_l_close'(+integer), [fct_name(l_close)]).

%l_search(+LDX, +BASE, +SCOPE, +FILTER, +ATTRS, +ATTRS_ONLY, -MSG_ID)
%
%LDX	inteiro c/ índice do link LDAP (p/ array interno)
%BASE	Átomo c/ base p/ pesquisa
%SCOPE	inteiro
%FILTER	Atomo c/ expressão de filtro (poderá ser construido em Prolog)
%ATTRS	lista de Atomos ou lista vazia (caso de lista vazia: retorna todos)
%	(nota: tentar alloca(3) em vez de malloc(3))
%ATTRS_ONLY	inteiro
%MSG_ID	inteiro

:- foreign('_l_search'(+integer, +string, +integer, +string, +term, +integer, -integer), [fct_name(l_search)]).

%l_result(+LDX, +MSG_ID, +ALL, +TIMEOUT, -RES_TYPE, -RESULT)
%
%MSG_ID	inteiro, como anteriormente ou o valor num=E9rico de LDAP_RES_ANY
%ALL	inteiro, 0=3Dresultados um a um, 1=3Dtodos
%TIMEOUT	termo, possibilidades:
%		timeval(INTEIRO_sec, INTEIRO_usec)
%		INTEIRO_usec (0 equiv. a "infinito")
%RES_TYPE	inteiro, indica qual a fun=E7=E3o que iniciou
%RESULT	para usar em ldap_*_entry e ldap_count_entries

:- foreign('_l_result'(+integer, +integer, +integer, +integer, -integer, -integer), [fct_name(l_result)]).

%l_msgfree(+MSG_ID)

:- foreign('_l_msgfree'(+integer), [fct_name(l_msgfree)]).

%l_count_entries(+LDX, +RESULT, -COUNT)
%
%COUNT	inteiro

:- foreign('_l_count_entries'(+integer,+integer,-integer), [fct_name(l_count_entries)]).

%l_entry(+LDX, +RESULT, -ENTRY)
%	[choice_size(1)]
%	n=E3o-deterministico, retorna as sucessivas entries.
%	guarda no choice-point o "next entry" (resultado do ldap_*_entry)
%
%ENTRY	inteiro
%:- foreign('_l_entry'(+integer, +integer, -integer), [choice_size(1)]).
% Não precisa de devolver nada porque o msg_id é sempre o mesmo
:- foreign(l_entry(+integer, +integer), [choice_size(1), fct_name(l_entry)]).

%l_attribute(+LD, +ENTRY, -ATRIB)
%	[choice_size(1)]
%	n=E3o-deterministico, retorna sucessivos atributos.
%	guarda no choice-point o "BerElement *"

%ATRIB	=E1tomo, nome do atributo, resultado de ldap_*_element

:- foreign('_l_attribute'(+integer, +integer, -string), [choice_size(1), fct_name(l_attribute)]).

%l_values(+LD, +ENTRY, +ATRIB, +BINARY, -VALUES)

%BINARY	integer
%VALUES lista com os valores para o atributo ATRIB
%
:- foreign('_l_values'(+integer, +integer, +string, +integer, -term), [fct_name(l_values)]).

%l_dn(+LD, +ENTRY, -DN)
:- foreign('_l_dn'(+integer, +integer, -string), [fct_name(l_dn)]).

% debugging stuff
:- foreign(connections, [fct_name(l_connections)]).
:- foreign(messages, [fct_name(l_messages)]).


%%%%
%%%
%%   EXPORTED API
%

init(Server, Port) :- '_l_init'(Server, Port, LDX).
init(Server) :- '_l_init'(Server, 389, LDX).
init :- '_l_init'(localhost, 389, LDX).

bind(Dn, Password) :- '_l_bind'(LDX, Dn, Password).
bind :- '_l_bind'(LDX, '','').

add(Dn, Data) :- '_l_add'(LDX, Dn, Data).

delete(Dn) :- '_l_del'(LDX, Dn).

close :- '_l_close'(LDX).

search(Base, Scope, Filter, Attrs, AttrsOnly, MsgID) :- 
	'_l_search'(LDX, Base, Scope, Filter, Attrs, AttrsOnly, MsgID).

result(MsgID, All, Timeout, ResType, Result) :-
	'_l_result'(LDX, MsgID, All, Timeout, ResType, Result).

msgfree(MsgID) :- '_l_msgfree'(MsgID).

count_entries(Result, Count) :- '_l_count_entries'(LDX, Result, Count).

%entry(Result, Entry) :- '_l_entry'(LDX, Result, Entry).
entry(MsgID) :- '_l_entry'(LDX, MsgID).

attribute(MsgId, Attribute) :- '_l_attribute'(LDX, MsgId, Attribute).

values(MsgId, Attribute, Binary, Values) :- 
	'_l_values'(LDX, MsgId, Attribute, Binary, Values).

dn(MsgId, DN) :- '_l_dn'(LDX, MsgId, DN).

