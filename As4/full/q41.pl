t0 :- ['graphs/p5'].
t1 :- ['graphs/p8'].
t2 :- ['graphs/p10'].
t3 :- ['graphs/p12'].
t4 :- ['graphs/p13'].
t5 :- ['graphs/p14'].
t6 :- ['graphs/p15'].
t7 :- ['graphs/p17'].
t8 :- ['graphs/p20'].
t9 :- ['graphs/p25'].
t10 :- ['graphs/p30'].
t11 :- ['graphs/p100'].
t12 :- ['graphs/p150'].
t13 :- ['graphs/p150_2'].
t14 :- ['graphs/p300'].

c(I) :- coloring(_,I).

%Checks the conection between Arc A and B
link(A,B):- arc(A,B).
link(A,B):- arc(B,A).

%Recursion for get the vertex list
listVertex_det(Ls,L):-
    vertex(X),
    \+ member(X,Ls),
    listVertex_det([X|Ls],L), !.
listVertex_det(Ls,L):-
    reverse(Ls,L).

%Get the vertex list
listVertex(L):-
    listVertex_det([],L).

%Recursion for Get the vertex linked list for a given vertex
listLinked_det(X,Ls,L):-
    link(X,Y),
    \+ member(Y,Ls),
    listLinked_det(X,[Y|Ls],L).
listLinked_det(_,Ls,L):-
    reverse(Ls,L).

%Get the vertex linked list for a given vertex
listLinked(X,L):-
    listLinked_det(X,[],L),
    !.

%Checks in the given vertex linked the color is used for another vertex
checkLinkedColor([],_,_).
checkLinkedColor([X|Ls],Color,Lc):-
    append([X],[Color],Elem),
    \+ member(Elem,Lc),
    checkLinkedColor(Ls,Color,Lc).

% Checks in the given color is valid on the vertex X
valid_color(X,Color,L):-
    listLinked(X,LLinked),
    checkLinkedColor(LLinked,Color,L),
    !.

% Recursion for do the coloring for all vertex, and return the list
% associated with the color to use, or false in case is not a solution
coloring_det([X|Ls],Lp,L):-
    color(Color),
    valid_color(X,Color,Lp),
    append([X],[Color],Elem),
    coloring_det(Ls,[Elem|Lp],L).
coloring_det([],Lp,L):-
    reverse(Lp,L).

% Do the coloring for all vertex, and return the list associated with
% the color to use, or false in case is not a solution
coloring(L):-
    listVertex(Lv),
    coloring_det(Lv,[],L),
    comp_statistics.

% Do the coloring for all vertex, and return the list associated with
% the color to use, or false in case is not a solution
coloring(Colors,L):-
    findall(C,color(C),Colors),
    coloring(L).

% Calculate the runtime for the main predicate
comp_statistics :-
   statistics(runtime,[_,X]),
   T is X/1000,
   nl,
   write('run time: '),
   write(T), write(' sec.'), nl.

%Do the test case and Print the result
test(BD):-
    consult(BD),
    coloring(L),
    write(L),
    !.

%test case 1
test1:-
    test('color1.pl').

%test case 2
test2:-
    test('color2.pl').
