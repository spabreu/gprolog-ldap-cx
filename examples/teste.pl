% $Id$

ldap(C) :> (
             init('server-dev.uevora.pt'),
             bind('cn=admin, dc=uevora, dc=pt', 'ad123'),
             search('ou=alunos, dc=uevora, dc=pt', 2, 'uid=l11269',
                    [uid, mail, givenName, userPassword], 0, M),
             result(M, 0, 0, X, R), attribute(R,A), values(R, A, 0, V)
           ).






%---------------------------------------------------------------------------
% $Log$
% Revision 1.1  2004/11/17 10:35:01  gjm
% Initial revision
%

