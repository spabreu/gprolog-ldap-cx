% $Id$


%%---------------------------------------------------------------------------
%% Initialization and server connection.
%%---------------------------------------------------------------------------

%% ldap_init(+host, +port, -ldx)
%%
%%   host           LDAP server hostname.
%%
%%   port           LDAP server port.
%%
%%   ldx            LDAP link.
%%
:- foreign(ldap_init(+string, +positive, -integer), [fct_name(l_init)]).


%% ldap_bind(+ldx, +dn, +password)
%%
%%   ldx            LDAP link.
%%
%%   dn             Bind DN.
%%
%%   password       Password
%%
:- foreign(ldap_bind(+integer, +string, +string), [fct_name(l_bind)]).


%% ldap_close(+ldx)
%%
%%   ldx            LDAP link.
%%
:- foreign(ldap_close(+integer), [fct_name(l_close)]).



%%---------------------------------------------------------------------------
%% Search.
%%---------------------------------------------------------------------------

%% ldap_search(+ldx, +base, +scope, +filter, +attrs, +attrs_only, -msgid)
%%
%%   ldx            LDAP link.
%%
%%   base           Search base.
%%
%%   scope          Search scope (0, to search the object itself, 1, to
%%                  search the object's immediate children or 2, to search
%%                  the object and all its descendents.
%%
%%   filter         The filter to apply in the search.
%%
%%   attrs          List of attributes to retrieve.
%%                  (NOTA: tentar alloca(3) em vez de malloc(3))
%%
%%   attrs_only	    If 1 only attribute types are wanted. If 0 both attribute
%%                  types and values are wanted.
%%
%%   msgid          Search result identifier.
%%
:- foreign(ldap_search(+integer, +string, +integer, +string, +term, +integer,
                       -integer),
           [fct_name(l_search)]).


%% ldap_result(+ldx, +msgid, +all, +timeout, -res_type, -result)
%%
%%   ldx            LDAP link.
%%
%%   msgid          Search result identifier.
%%
%%   all            Should always be 0
%%
%%   timeout        Timeout. Can be timeval(SECs, MICROSECs) or an
%%                  MICROSECs (0 means "infinite").
%%
%%   res_type       Ignore.
%%
%%   result         Result identifier.
%%
:- foreign(ldap_result(+integer, +integer, +integer, +integer,
                       -integer, -integer),
           [fct_name(l_result)]).



%%---------------------------------------------------------------------------
%% Information retrieval.
%%---------------------------------------------------------------------------

%% ldap_count_entries(+ldx, +result, -count)
%%
%%   ldx            LDAP link.
%%
%%   result         Result identifier.
%%
%%   count          Number of objects returned.
%%
%%
:- foreign(ldap_count_entries(+integer, +integer, -integer),
           [fct_name(l_count_entries)]).


%% ldap_entry(+ldx, +result)
%%
%%   ldx            LDAP link.
%%
%%   result         Result identifier.
%%
%%
:- foreign(ldap_entry(+integer, +integer),
           [choice_size(1), fct_name(l_entry)]).


%% ldap_attribute(+ldx, +result, -attrib)
%%
%%   ldx            LDAP link.
%%
%%   result         Result identifier.
%%
%%   attrib         Attribute.
%%
:- foreign(ldap_attribute(+integer, +integer, -string),
           [choice_size(1), fct_name(l_attribute)]).


%% ldap_values(+ldx, +result, +attrib, +binary, -values)
%%
%%   ldx            LDAP link.
%%
%%   result         Result identifier.
%%
%%   attrib         The attribute to get the values for.
%%
%%   binary         If set to 1 gets the values in binary format.
%%
%%   values         List with the attribute's values.
%%
:- foreign(ldap_values(+integer, +integer, +string, +integer, -term),
           [fct_name(l_values)]).


%% ldap_dn(+ldx, +result, -dn)
%%
%%   ldx            LDAP link.
%%
%%   result         Result identifier.
%%
:- foreign(ldap_dn(+integer, +integer, -string), [fct_name(l_dn)]).



%%---------------------------------------------------------------------------
%% Add/Modify/Delete.
%%---------------------------------------------------------------------------

%% ldap_add(+ldx, +dn, +data)
%%
%%   ldx            LDAP link.
%%
%%   dn             DN to add.
%%
%%   data           Data to be added.
%%
:- foreign(ldap_add(+integer, +string, +term), [fct_name(l_add)]).


%% ldap_modify(+ldx, +dn, +data)
%%
%%   ldx            LDAP link.
%%
%%   dn             DN to modify.
%%
%%   data           Data to be modified.
%%
:- foreign(ldap_modify(+integer, +string, +term), [fct_name(l_modify)]).


%% ldap_delete(+ldx, +dn)
%%
%%   ldx            LDAP link.
%%
%%   dn             DN to delete.
%%
:- foreign(ldap_delete(+integer, +string), [fct_name(l_del)]).



%---------------------------------------------------------------------------
% $Log$
% Revision 1.3  2004/12/06 12:13:23  gjm
% Added foreign ldap_modify/3.
%
% Revision 1.2  2004/11/18 15:53:48  gjm
% Added foreign ldap_close/1, ldap_add/3 and ldap_delete/2.
%
% Revision 1.1.1.1  2004/11/17 10:35:01  gjm
% Initial revision.
%

