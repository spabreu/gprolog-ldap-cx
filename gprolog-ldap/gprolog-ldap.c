/* $Id$ */

/****************************************************\
*                                                    *
*         ProLDAP - API em Prolog para LDAP          *
*                                                    *
*     Pedro Patinho - Projecto de Fim de Curso       *
*        Universidade de Évora - 2000/2001           *
*                                                    *
*            ( parte I - código em C )               *
*                                                    *
\****************************************************/

#include <lber.h>
#include <ldap.h>
#include <gprolog/gprolog.h>
#include <errno.h>
#include <string.h>

#include "memory.h"
#include "pl_exceptions.h"

//#undef DEBUG
//#define DEBUG                /* alpha version */

/* l_init(+host, +port, -ldx) */

Bool l_init (char *host, int port, int *conn)
{
  LDAP *ld;
  int new_conn;

  initialize_ldap();

  if ((ld = ldap_init(host, port)) == NULL) {
    Proldap_err(strerror(errno));
    return FALSE;
  }


  if ( (new_conn = new_connection(ld)) == -1 ) {
    Proldap_err_maxconnections();
    return FALSE;
  }

#ifdef DEBUG
  printf("[l_init] Connected!\n");
#endif

  *conn = new_conn;
  return TRUE;
}


/* l_bind(+ldx, +dn, +password) */

Bool l_bind (int conn, char *dn, char *password)
{
  int i;
  int rc;

  initialize_ldap();

  if (!check_connection(conn)) {
    Proldap_err_connect();
    return FALSE;
  }

  if ( (rc = ldap_simple_bind_s(ldap_connections[conn], dn, password)) 
       != LDAP_SUCCESS) {
    Proldap_err(ldap_err2string(rc));
    return FALSE;
  }

#ifdef DEBUG
  printf("[l_bind] Successful Bind!\n");
#endif

  return TRUE;
}


/* decifra_atomo() - traduz um átomo numa estrutura LDAPMod */

LDAPMod **decifra_atomo(PlTerm *atomo, int arity)
{
  int i, j;
  int f[arity], a[arity];
  PlTerm *l[arity];
  LDAPMod **ret = (LDAPMod **) malloc ((arity+1) * sizeof(LDAPMod *));
  
  for (i = 0; i < arity; i++) {
    if ( Blt_Compound(atomo[i]) ) {

#ifdef DEBUG
  printf("[decifra_atomo] É um compound!\n");
#endif

      l[i] = Rd_Compound_Check(atomo[i], &(f[i]), &(a[i]));

#ifdef DEBUG
      printf("[decifra_atomo] functor/arity: %s/%d\n", Atom_Name(f[i]), a[i]);
#endif

      ret[i] = (LDAPMod *) malloc (sizeof(LDAPMod));
      ret[i]->mod_op = 0;  /* ignorado */
      ret[i]->mod_type = Atom_Name(f[i]);

#ifdef DEBUG
      printf("[decifra_atomo] ATRIBUTO: %s\n", ret[i]->mod_type);
#endif

      /* temos que criar uma entrada para cada sub-argumento */
      ret[i]->mod_values = 
	(char **) malloc ((a[i]+1)*sizeof(*ret[i]->mod_values));
      for (j = 0; j < a[i]; j++) {
	ret[i]->mod_values[j] = Rd_String_Check(l[i][j]);

#ifdef DEBUG
	printf("[decifra_atomo] Entrada: %s\n", ret[i]->mod_values[j]);
#endif

      }
      ret[i]->mod_values[j] = NULL;
    }
    else {

#ifdef DEBUG
      printf("[decifra_atomo] ERRO: É do tipo: %d!\n", Type_Of_Term(atomo[i]));
#endif

      return NULL;
    }
  }
  ret[i] = NULL;

  return ret;
}


/* l_add(+ldx, +dn, +dados) */

Bool l_add (int conn, char *dn, PlTerm dados)
{
  int f, a, rc;
  PlTerm *atomo;
  LDAPMod **attrs;
  
  initialize_ldap();

  if (!check_connection(conn)) {
    Proldap_err_connect();
    return FALSE;
  }

  atomo = Rd_Compound_Check(dados, &f, &a);

#ifdef DEBUG
  printf("[l_add] FUNCTOR: %s\n", Atom_Name(f));
  printf("[l_add] ARIDADE: %d\n", a);
#endif

  /* primeiro temos de "decifrar" o átomo */
  attrs = decifra_atomo(atomo, a);
  
  /* depois metemos a info no servidor */
  if ( (rc = ldap_add_s(ldap_connections[conn], dn, attrs)) != LDAP_SUCCESS) {
    Proldap_err(ldap_err2string(rc));
    return FALSE;
  }

#ifdef DEBUG
  printf("[l_add] Data added\n");
#endif
  return TRUE;
}


Bool l_del(int conn, char *dn)
{
  int rc;

  initialize_ldap();

  if (!check_connection(conn)) {
    Proldap_err_connect();
    return FALSE;
  }

  if ( (rc = ldap_delete_s(ldap_connections[conn], dn)) != LDAP_SUCCESS ) {
    Proldap_err(ldap_err2string(rc));
    return FALSE;
  }

  return TRUE;
}

Bool l_close(int conn)
{
  int rc;

  initialize_ldap();

  if (!check_connection(conn)) {
    Proldap_err_connect();
    return FALSE;
  }

  if ( (rc = ldap_unbind_s(ldap_connections[conn])) != LDAP_SUCCESS) {
    Proldap_err(ldap_err2string(rc));
    return FALSE;
  }
  ldap_connections[conn] = NULL;
  return TRUE;  
}


/* ldap_search(+LDX, +BASE, +SCOPE, +FILTER, +ATTRS, +ATTRS_ONLY, -MSG_ID) */

Bool l_search (int conn, char *base, int scope, char *filter, 
	       PlTerm attrs_list, int attrs_only, int *msg_id)
{
  PlTerm lista[MAXLISTSIZE];
  int i, size;
  char **attrs;
  char *atributo;

  if (!check_connection(conn)) {
    Proldap_err_connect();
    return FALSE;
  }

  if ( (size = Rd_Proper_List_Check(attrs_list, lista)) < 0 ) { 
    Pl_Err_Type(type_list, attrs_list);
    return FALSE;
  }

#ifdef DEBUG
  printf("[l_search] Tamanho da lista de atributos: %d\n", size);
#endif

  /* Vamos "descascar" a lista */

  /*********************************/  
  /* CUIDADO: TRATAR A LISTA VAZIA */
  /*********************************/  

  attrs = (char **) alloca (size * sizeof(char *) + 1);

  for (i = 0; i < size; i++) {
    atributo = Rd_String_Check(lista[i]);
    attrs[i] = (char *) alloca (strlen(atributo) * sizeof(char) + 5);
    strcpy(attrs[i], atributo);

#ifdef DEBUG
    printf("[l_search] ATRIBUTO[%d] = %s\n", i, atributo);
#endif

  }
  attrs[i] = NULL;

  

  if ( (*msg_id = ldap_search(ldap_connections[conn], base, scope, filter, attrs, attrs_only)) 
      == -1 ) {
    Proldap_err_search();
    return FALSE;
  }

  return TRUE;
}

Bool l_result (int conn, int msg_id, int all, int timeout, int *res_type, 
	       int *res_ptr)
{
  int new_msg;
  struct timeval *tv;
  LDAPMessage *result;
  
  initialize_ldap();

  if (!check_connection(conn)) {
    Proldap_err_connect();
    return FALSE;
  }

  /*** ALTERAR AQUI PARA SUPORTAR TERMOS TB ***/
  if (timeout == 0) {
    tv = NULL;
  }
  else {
    tv = (struct timeval *) alloca (sizeof (struct timeval)); 
    tv->tv_sec = timeout;
    tv->tv_usec = 0;
  }
  /********************************************/

  if ( (*res_type = ldap_result(ldap_connections[conn], msg_id, all, tv, &result) ) == -1 ) {
    Proldap_err_result();
    return FALSE;
  }
  else if (*res_type == 0) {
    Proldap_err_timeout();
    return FALSE;
  }

  /* allocate a LDAP message in the static array */
  if ( (new_msg = new_message(result)) == -1 ) {
    Proldap_err_maxmessages();
    return FALSE;
  }
  *res_ptr = new_msg;

#ifdef DEBUG
  printf("[l_result] Alocada a mensagem inicial. Endereço %x\n", result);
#endif

  return TRUE;
}

void l_msgfree(int msg)
{
  initialize_ldap();

#ifdef DEBUG
  printf("[l_msgfree] deallocating message id %d...\n", msg);
#endif

  if (!check_message(msg)) {
    Proldap_err_message();
  }


#ifdef DEBUG
  printf("[l_msgfree] which points to address %x...\n", ldap_messages[msg].initial_msg);
#endif

  ldap_msgfree(ldap_messages[msg].initial_msg);
  ldap_messages[msg].initial_msg = NULL;

#ifdef DEBUG
  printf("[l_msgfree] done.\n");
#endif
}


Bool l_count_entries(int conn, int msg, int *count)
{
  initialize_ldap();

  if (!check_connection(conn)) {
    Proldap_err_connect();
    return FALSE;
  }

  if (!check_message(msg)) {
    Proldap_err_message();
    return FALSE;
  }

  *count = ldap_count_entries(ldap_connections[conn], ldap_messages[msg].initial_msg);

  return TRUE;
}

Bool l_entry(int conn, int msg) //, int *msg_out)
{
  LDAPMessage *result;
  int *buffermsg;
  //  int new_msg;

  initialize_ldap();

  if (!check_connection(conn)) {
    Proldap_err_connect();
    return FALSE;
  }

  if (!check_message(msg)) {
    Proldap_err_message();
    return FALSE;
  }
  
  /** PARTE NÃO DETERMINÍSTICA **/

  buffermsg = Get_Choice_Buffer(int *);
  
#ifdef DEBUG
  printf("[l_entry] Choice_Counter = %d\n", Get_Choice_Counter());
#endif

  if (Get_Choice_Counter() == 0) {
    result = ldap_first_entry(ldap_connections[conn], 
			      ldap_messages[msg].initial_msg);
    Create_Water_Mark (&l_msgfree, (void*) msg);
  }
  else {
    result = ldap_next_entry(ldap_connections[conn], 
			     ldap_messages[*buffermsg].curr_msg);
  }
  
  if (!result) {
    No_More_Choice();
    return FALSE;
  }

  /*
  if ( (new_msg = new_message(result)) == -1 ) {
  Proldap_err_maxmessages();
  return FALSE;
  }
  
  #ifdef DEBUG
  if (check_message(new_msg)) {
  printf("[l_entry] Generated valid message (LDAPMessage *) %x\n", ldap_messages[new_msg]);
  }
  else {
  printf("[l_entry] Generated INVALID message\n");
  return FALSE;
  }
  #endif
  */
  
  //  *msg_out = new_msg;

  *buffermsg = msg;
  set_next_message(msg, result);

#ifdef DEBUG
  printf("[l_entry] setting next message as address %x\n", result);
#endif

  return TRUE;
  
  /*
  for (i=0; i<LDAP_MAX_MESSAGES; ++i) {
    int prev_i = *buffermsg;
    if (!ldap_messages[i]) {
      ldap_messages[i] = result;
      *msg_out = i;
      *buffermsg = i;
      if (Get_Choice_Counter() == 0)
	Create_Water_Mark (l_msgfree, (void*) i);
      else {
	l_msgfree(prev_i);
	Update_Water_Mark (l_msgfree, (void*) i);
      }
      return TRUE;
    }
  }
  */

}


Bool l_attribute(int conn, int msg, char **attr)
{
  LDAPMessage *result;
  BerElement **buffer;
  int i;

  initialize_ldap();

  if (!check_connection(conn)) {
    Proldap_err_connect();
    return FALSE;
  }

  if (!check_message(msg)) {
    Proldap_err_message();
    return FALSE;
  }

  
  /** PARTE NÃO DETERMINÍSTICA **/

  buffer = Get_Choice_Buffer(BerElement **);
  
  if (Get_Choice_Counter() == 0) {
    *attr = ldap_first_attribute(ldap_connections[conn], 
				 ldap_messages[msg].curr_msg, buffer);
  }
  else {
    *attr = ldap_next_attribute(ldap_connections[conn], 
				ldap_messages[msg].curr_msg, *buffer);
  }
  
  if (*attr == NULL) {
    No_More_Choice();
    return FALSE;
  }
  
  return TRUE;
}


Bool l_values(int conn, int msg, char *attr, int bin, PlTerm *values)
{
  PlTerm *lista = (PlTerm *) alloca (MAXLISTSIZE * sizeof(PlTerm));
  char **attr_list;
  int i;

  initialize_ldap();

  if (!check_connection(conn)) {
    Proldap_err_connect();
    return FALSE;
  }

  if (!check_message(msg)) {
    Proldap_err_message();
    return FALSE;
  }

  /* USAR GET_VALUES_LEN sse BIN == 1 */
  
  attr_list = ldap_get_values(ldap_connections[conn], 
			      ldap_messages[msg].curr_msg, attr);

  if (!attr_list) {
    Proldap_err_attribute();
    return FALSE;    
  }
  /* construção da lista a partir da array de strings */
  for(i = 0; attr_list[i]; i++) {
    lista[i] = Mk_String (attr_list[i]);
  }

  *values = Mk_Proper_List (i, lista);

  /* ldap_value_free(attr_list); */

  return TRUE;
}

/*
  char *ldap_get_dn(ld, entry)
  LDAP *ld;
  LDAPMessage *entry;
*/

Bool l_dn(int conn, int msg, char **dn)
{
  if (!check_connection(conn)) {
    Proldap_err_connect();
    return FALSE;
  }

  if (!check_message(msg)) {
    Proldap_err_message();
    return FALSE;
  }

  if ( (*dn = ldap_get_dn(ldap_connections[conn], 
			  ldap_messages[msg].curr_msg)) == NULL ) {
    Proldap_err("Error getting distinguished name");
    return FALSE;
  }
  
  return TRUE;
}

Bool l_ufn(int conn, int msg, char **dn)
{
  char *dn_tmp;

  if (!check_connection(conn)) {
    Proldap_err_connect();
    return FALSE;
  }

  if (!check_message(msg)) {
    Proldap_err_message();
    return FALSE;
  }

  if ( (dn_tmp = ldap_get_dn(ldap_connections[conn], 
			  ldap_messages[msg].curr_msg)) == NULL ) {
    Proldap_err("Error getting distinguished name");
    return FALSE;
  }
  
  *dn = ldap_dn2ufn(dn_tmp);

#ifdef DEBUG
  printf("[l_dn] DN: %s\n", dn_tmp);
  printf("[l_dn] UFN: %s\n", *dn);
#endif

  return TRUE;
}


/********************************
 *                              *
 *         DEBUG STUFF          *
 *                              *
 ********************************/

#ifdef DEBUG

Bool l_connections(void)
{
  int i;

  printf("Ligações activas:\n");
  for (i = 0; i < LDAP_MAX_CONNECTIONS; i++) {
    if (ldap_connections[i] != NULL) {
      printf("%d  ", i);
    }
  }
}

Bool l_messages(void)
{
  int i;

  printf("Mensagens alocadas:\n");
  for (i = 0; i < LDAP_MAX_MESSAGES; i++) {
    if (check_message(i)) {
      printf("%d  ", i);
    }
  }
}

#else

Bool l_connections(void)
{
  return FALSE;
}

Bool l_messages(void)
{
  return FALSE;
}

#endif

/*
$Log$
Revision 1.1  2004/11/17 10:35:01  gjm
Initial revision

Revision 1.1.1.1  2004/11/03 11:42:49  pp
Initial CX version.


Revision 1.15  2001/06/13 02:06:53  pedro
corrigida a função l_dn que devolvia sempre o dn da 1ª entry

adicionada a função l_ufn que devolve o DN na forma UFN (User Friendly Naming)

Revision 1.14  2001/06/13 01:50:18  pedro
(l_dn): devolve o DN a partir de uma entry

Revision 1.13  2001/06/13 01:12:53  pedro
Parece que agora já funciona bem :).

Revision 1.12  2001/06/13 01:01:46  pedro
Agora já compila. Vamos ver se funciona ok.

Revision 1.11  2001/06/13 01:00:20  pedro
Apenas mudanças ao nível visual do código

Revision 1.10  2001/06/13 00:56:10  pedro
funções l_attribute e l_values modificadas para suportar o novo sistema de "exception raising" e nova estrutura L_MESSAGE.

Revision 1.9  2001/06/13 00:53:13  pedro
(l_entry): Grandes mudanças: Create_Water_Mark() já deverá funcionar correctamente; mudança para a nova estrutura L_MESSAGE; utilização de apenas 2 argumentos.

Revision 1.8  2001/06/10 17:21:20  pedro
As funções ldap_result(), ldap_first_entry() e ldap_next_entry() devolvem (algumas vezes ???) apontadores para o mesmo sítio (LDAPMessage *).
Por isso é que a função l_msgfree() falha (desaloca 2 vezes o mesmo).
Solução a fermentar...

Revision 1.7  2001/06/10 11:55:51  pedro
Algum trabalho na função l_entry (ainda não está OK)

Revision 1.6  2001/06/10 03:02:24  pedro
*** empty log message ***

Revision 1.5  2001/06/10 02:52:21  pedro
Várias modificações a nível da sinalização de erros: são chamadas as funções Proldap_err_* para lançar as excepções

Utilização das funções 'new_connection()' e 'new_message()', adicionadas ao ficheiro memory.h

Revision 1.4  2001/06/10 01:52:14  pedro
*** empty log message ***

Revision 1.3  2001/06/09 20:32:27  pedro
* Adicionada a função l_connections()

*/
