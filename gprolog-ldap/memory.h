/* $Id$ */

/*
$Log$
Revision 1.1  2004/11/17 10:35:01  gjm
Initial revision

Revision 1.1.1.1  2004/11/03 11:42:49  pp
Initial CX version.


Revision 1.8  2001/06/13 00:51:26  pedro
função initial_message removida

mudança de nome de next_message() para set_next_message()

Revision 1.7  2001/06/13 00:37:06  pedro
Mudança de nomes:
. set_message() -> initial_message()
. old_message() -> next_message()

Revision 1.6  2001/06/13 00:35:44  pedro
Nova estrutura L_MESSAGE para suportar as alocações de memória relativas às
LDAPMessages

Nova função set_message, para atribuir um valor inicial à L_MESSAGE

Algumas mudanças nas funções antigas para suportar o novo formato

Revision 1.5  2001/06/10 22:40:14  pedro
Função new_message novamente da forma antiga

(old_message): nova função para devolver o índice da mensagem já existente

Revision 1.4  2001/06/10 18:29:59  pedro
(new_message): Procura primeiro no vector ldap_messages[] se já existe um apontador para msg. Se existir não aloca um espaço novo, apenas devolve o índice que já existe.

Revision 1.3  2001/06/10 02:46:44  pedro
(new_connection): Nova função para alocar ligações no vector ldap_connections[]

Revision 1.2  2001/06/10 02:42:41  pedro
(new_message): Nova função para alocar mensagens no vector ldap_messages[]

Revision 1.1  2001/06/10 00:16:58  pedro
* Separação das variáveis estáticas e funções associadas do ficheiro proldap.c

*/

/*
 * memory.h - gestão da memória para a API ProLDAP
 *
 * variáveis estáticas, funções para alocação e libertação de memória
 * e funções para a gestão das variáveis estáticas
 *
 * Pedro Patinho - 2000/2001
 *
 */

#ifndef MEMORY_H_
#define MEMORY_H_

#define MAXLISTSIZE    100
#define MAXSTRSIZE     1024
#define LDAP_MAX_CONNECTIONS  16
#define LDAP_MAX_MESSAGES     512

typedef struct l_message {
  LDAPMessage *initial_msg;
  LDAPMessage *curr_msg;
} L_MESSAGE;

/** Variáveis estáticas **/

static Bool ldap_initialized = FALSE;
static LDAP *ldap_connections[LDAP_MAX_CONNECTIONS];
static L_MESSAGE ldap_messages[LDAP_MAX_MESSAGES];

static inline void initialize_ldap () {
  if (!ldap_initialized) {
    int i;
    for (i = 0; i < LDAP_MAX_CONNECTIONS; i++) {
      ldap_connections[i] = NULL;
    }
    for (i = 0; i < LDAP_MAX_MESSAGES; i++) {
      ldap_messages[i].initial_msg = NULL;
    }
    ldap_initialized = TRUE;
  }
}

static inline Bool check_connection(int conn)
{
  if (ldap_connections[conn] == NULL) 
    return FALSE;
  return TRUE;
}

static inline Bool check_message(int msg)
{
  if (ldap_messages[msg].initial_msg == NULL) 
    return FALSE;
  return TRUE;
}

static inline int new_connection(LDAP *ld)
{
  int i;

  for (i=0; i<LDAP_MAX_CONNECTIONS; i++) {
    if (!ldap_connections[i]) {
      ldap_connections[i] = ld;
      return i;
    }
  }
  return -1; /* ldap_connections[] is full */
}

static inline int new_message(LDAPMessage *msg)
{
  int i;

  for (i=0; i<LDAP_MAX_MESSAGES; i++) {
    if (!ldap_messages[i].initial_msg) {
      ldap_messages[i].initial_msg = msg;
      ldap_messages[i].curr_msg = msg;
      return i;
    }
  }

  return -1; /* ldap_messages[] is full */
}

static inline void set_next_message(int msg_id, LDAPMessage *msg)
{
  ldap_messages[msg_id].curr_msg = msg;
}


#endif
