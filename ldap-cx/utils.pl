% $Id$


%%---------------------------------------------------------------------------
%% Unifies VALUE with the value of the term NAME=VALUE, in the list LIST,
%% or DEFAULT if it doesn't exist.
%%---------------------------------------------------------------------------

member_default(LIST, NAME, VALUE, _) :- memberchk(NAME=VALUE, LIST), !.
member_default(LIST, NAME, DEFAULT, DEFAULT).




%---------------------------------------------------------------------------
% $Log$
% Revision 1.1  2004/11/17 10:35:01  gjm
% Initial revision
%

