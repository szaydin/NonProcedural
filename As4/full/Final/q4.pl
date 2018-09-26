:- use_module(library(clpfd)).
:- include("tests-SSS.pl").

% Generate the all combination using the all elements inner in the given
% List
combination(As,Bs) :-
   same_length(As,Full),
   Bs = [_|_],
   prefix(Bs,Full),
   foldl(select,Bs,As,_).

% Generate a list from 1 to N integers
list_to_n(N,List):-
   length(List,N),
   List ins 1..N,
   all_different(List),
   once(label(List)).

% Generate a List From L1 to L2, the L1 has the indexes values to get from L2.
get_mapped([],_,Ls,L):-
   reverse(Ls,L),
   !.
get_mapped([X|Xs],Source,Ls,L):-
   nth1(X,Source,Y),
   get_mapped(Xs,Source,[Y|Ls],L).

%Start Point for do the testcases
subsetsum(L,N):-
   length(L,N2),
   list_to_n(N2,LMap),
   combination(LMap,Lc),
   get_mapped(Lc,L,[],LMapped),
   sum_list(LMapped,N),
   write(LMapped), nl,
   comp_statistics.

comp_statistics:-
   statistics(runtime,[_,X]),
   T is X/1000,
   nl,                                         % write to screen
   write('run time: '),
   write(T), write(' sec.'), nl,
   Min is T / 60,
   Min =< 2,
   write('Done in less than 2 minutes').
comp_statistics.


