% $Id$


%%---------------------------------------------------------------------------
%% Unifies VALUE with the value of the term NAME=VALUE, in the list LIST,
%% or DEFAULT if it doesn't exist.
%%
%% member_default(+list, ?name, ?value, ?default)
%%---------------------------------------------------------------------------

member_default(LIST, NAME, VALUE, _) :- memberchk(NAME=VALUE, LIST), !.
member_default(_, _, DEFAULT, DEFAULT).



%---------------------------------------------------------------------------
% $Log$
% Revision 1.3  2005/03/04 15:59:35  gjm
% *** empty log message ***
%
% Revision 1.2  2004/11/18 15:52:18  gjm
% *** empty log message ***
%
% Revision 1.1.1.1  2004/11/17 10:35:01  gjm
% Initial revision.
%

