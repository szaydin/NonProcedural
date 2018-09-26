:- use_module(library(clpfd)).


% Generate the all combination using the all elements inner in the given
% List
combination(As,Bs) :-
   same_length(As,Full),
   Bs = [_|_],
   prefix(Bs,Full),
   foldl(select,Bs,As,_).

%Start Point for do the testcases
subsetsum(L,N):-
    combination(L,Lc),
    sum_list(Lc,N),
    write(Lc), nl,
    comp_statistics,
    failed.

%Consulting the testcases from the file "tests-SSS.pl"
:- consult('tests-SSS.pl').

comp_statistics :-

statistics(runtime,[_,X]),

T is X/1000,

nl,                                         % write to screen

write('run time: '),

write(T), write(' sec.'), nl.
