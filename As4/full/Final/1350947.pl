% Sumeyye Aydin , 1350947
% Cmput 325
% Assignment 3
% I added all files in one but it messes up since I had to use same predicates since I worked seperately for each question
% I also included q2.pl , q3.pl q4.pl and q5.pl files. If you can test them seperately it would be realyl great.

/* ----------------Question 2 ------------------*/

:- use_module(library(clpfd)).
:- use_module(library(lists)).
:-style_check(-discontiguous).

%Remove a element X from a List, returning the List without X Element.
remove(X,[X|Xs],Xs).
remove(X,[Y|Ys],[Y|Zs]):-
    remove(X,Ys,Zs).

% Review and Checks that the all disarms are less than or equal to the
% next disarm
verify_months([]).
verify_months([_]).
verify_months([[X|_],[Y|Ly]|Ls]):-
    sum_list(X,Sx),
    sum_list(Y,Sy),
    Sx =< Sy,
    verify_months([[Y|Ly]|Ls]).

%Do the recursion for disarm the forces from the countries
disarm_det([],[],L,L).
%Case when Country A remove 2 Forces
disarm_det(La,Lb,Ls,L):-
    select(Xa,La,La1),
    select(Ya,La1,Laa),
    select(Xb,Lb,Lbb),
    Xb is Xa + Ya,
    append([[Xa,Ya]],[[Xb]],Elem),
    reverse([Elem|Ls],TempL),
    verify_months(TempL),
    disarm_det(Laa,Lbb,[Elem|Ls],L).
%Case when Country B remove 2 Forces
disarm_det(La,Lb,Ls,L):-
    select(Xb,Lb,Lb1),
    select(Yb,Lb1,Lbb),
    select(Xa,La,Laa),
    Xa is Xb + Yb,
    append([[Xa]],[[Xb,Yb]],Elem),
    reverse([Elem|Ls],TempL),
    verify_months(TempL),
    disarm_det(Laa,Lbb,[Elem|Ls],L).

%Do the disarm forces from the countries, verifying all disarms
disarm(La,Lb,L):-
    disarm_det(La,Lb,[],Lp),
    reverse(Lp,L),
%    verify_months(L),
    !.

%Print one month disarm
print_elem([Xa,Xb],[Y]):-
    write('A dismantles '), write(Xa), write(' and '), write(Xb), write(', '),
    write('B dismantles '), write(Y).
print_elem([X],[Ya,Yb]):-
    write('A dismantles '), write(X), write(', '),
    write('B dismantles '), write(Ya), write(' and '), write(Yb).

%Print all months disarm
print_all([]).
print_all([[X,Y]|Ls]):-
    print_elem(X,Y), !, nl,
    print_all(Ls), !.

%Do the test case and Print the result
test(Ca,Cb):-
    write('Country A:'), write(Ca), nl,
    write('Country B:'), write(Cb), nl, nl,
    disarm(Ca,Cb,L),
    write('Solution: '), write(L), nl, nl,
    print_all(L),
    !.

%personal test case 1
test1:-
    test([1,3,3,4,6,10,12],[3,4,7,9,16]).

%personal test case 2
test2:-
    test([1,3,3,4,6,10,12],[4,7,9,16]).

%anothers test cases

p1(S):-
    disarm([1,3,3,4,6,10,12],[3,4,7,9,16],S).
%S = [[[1, 3], [4]], [[3, 6], [9]], [[10], [3, 7]], [[4, 12], [16]]].

p2:-
    disarm([],[],[]).
%true.

p3(S):-
    disarm([1,2,3,3,8,5,5],[3,6,4,4,10],S).
%S = [[[1, 2], [3]], [[3, 3], [6]], [[8], [4, 4]], [[5, 5], [10]]].

p4(S):-
    disarm([1,2,2,3,3,8,5],[3,2,6,4,4,10],S).
%false.

p5(S):-
    disarm([1,2,2,3,3,8,5,5,6,7],[3,2,6,4,4,10,1,5,2],S).
%false.

p6(S):-
    disarm([1,2,2,116,3,3,5,2,5,8,5,6,6,8,32,2],[3,5,11,4,37,1,4,121,3,3,14],S).
%S = [[[1, 2], [3]], [[2, 2], [4]], [[2, 3], [5]], [[5], [4, 1]], [[6], [3, 3]], [[3, 8], [11]], [[6|...], [...]], [[...|...]|...], [...|...]].

p2T(S):-
    statistics(runtime,[T0|_]),
    p6(S),
    statistics(runtime, [T1|_]),
    T is T1 - T0,
    format('p6/1 takes ~3d sec.~n', [T]).
%disarm takes 11.755 sec.
%S = [[[1, 2], [3]], [[2, 2], [4]], [[2, 3], [5]], [[5], [4, 1]], [[6], [3, 3]], [[3, 8], [11]], [[6|...], [...]], [[...|...]|...], [...|...]].

/* ---------------------------- Question 3 ---------------------------*/

t0 :- ['Q3tests/t0'].
t1 :- ['Q3tests/t1'].
t2 :- ['Q3tests/t2'].
t3 :- ['Q3tests/t3'].
t4 :- ['Q3tests/t4'].
t5 :- ['Q3tests/t5'].

% tests
q(P) :- seating(P,2).
q1(P) :- seating(P,3).

%Checks likes guest bidirectional
bilike(X,Y):- like(X,Y).
bilike(X,Y):- like(Y,X).

%Checks dislikes guest bidirectional
bidislike(X,Y):- dislike(X,Y).
bidislike(X,Y):- dislike(Y,X).

%Recursion for get a List with all Tables
listTable_det(Ls,L):-
    table(X),
    append([X],[[]],Elem),
    \+ member(Elem,Ls),
    listTable_det([Elem|Ls],L),
    !.
listTable_det(Ls,L):-
    reverse(Ls,L),
    !.

%Get a List with all Tables
listTable(L):-
    listTable_det([],L).

%Recursion for get a List with all Guests
listGuest_det(Ls,L):-
    guest(X),
    \+ member(X,Ls),
    listGuest_det([X|Ls],L),
    !.
listGuest_det(Ls,L):-
    reverse(Ls,L),
    !.

%Get a List with all Guests
listGuest(L):-
    listGuest_det([],L).

%Assign a Guest to a Table
insertGuest(_,_,[],Lp,L):-
    reverse(Lp,L),
    !.
insertGuest(Guest,NTable,[[NTable,LGuest]|Ls],NewLTables,L):-
    append([Guest],LGuest,NewLGuest),
    insertGuest(Guest,NTable,Ls,[[NTable,NewLGuest]|NewLTables],L),
    !.
insertGuest(Guest,NTable,[X|Ls],NewLTables,L):-
    insertGuest(Guest,NTable,Ls,[X|NewLTables],L),
    !.

%Recursion for create a List with a given number with n times repeated
buildListOfNumber_det(_,0,Lp,L):-
    reverse(Lp,L),
    !.
buildListOfNumber_det(X,N,Lp,L):-
    N1 is N - 1,
    buildListOfNumber_det(X,N1,[X|Lp],L),
    !.

%Create a List with a given number with n times repeated
buildListOfNumber(X,N,L):-
    buildListOfNumber_det(X,N,[],L).

%Generate a List with Numbers of Tables assigned to the Guests
parseListTables([],Lp,L):-
    reverse(Lp,L),
    !.
parseListTables([[NTable,LGuest]|Ls],Lp,L):-
    length(LGuest,N),
    buildListOfNumber(NTable,N,LN),
    append(LN,Lp,Lpf),
    parseListTables(Ls,Lpf,L),
    !.

%Checks if the given Guest is Valid in the List of Guest given
validGuest(_,[]):-
    !.
validGuest(Guest,[AGuest|_]):-
    bidislike(Guest,AGuest),
    !,
    fail.
validGuest(Guest,[AGuest|_]):-
    bilike(Guest,AGuest),
    !.
validGuest(Guest,[_|LGuest]):-
    validGuest(Guest,LGuest).

%Obtains the List of the Guest assigned to a given Table number
getListGuestFromTable(NTable,[[NTable,LGuest]|_],LGuest):- !.
getListGuestFromTable(NTable,[_|Ls],L):-
    getListGuestFromTable(NTable,Ls,L).

%Recursion for the solution for assign the seats
%resolve_det(_,LTables,[],LTables).
resolve_det(_,LTables,[],L):-
    maplist(writeln,LTables),
    parseListTables(LTables,[],L).
resolve_det(N,LTables,[Guest|LGuest],L):-
    table(NTable),
    getListGuestFromTable(NTable,LTables,LGuestTable),
    length(LGuestTable,NGuestTable),
    NGuestTable < N,
    validGuest(Guest,LGuestTable),
    insertGuest(Guest,NTable,LTables,[],NewLTables),
    resolve_det(N,NewLTables,LGuest,L).

%Do the solution for assign the seats
resolve(N,L):-
    listTable(LTables),
    listGuest(LGuest),
    resolve_det(N,LTables,LGuest,L).

%Start Point for do the testcases
seating(L,N):-
    resolve(N,L).
/* ------------------------------ Question 4 --------------------------*/

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

/* -------------------------- Question 5 ----------------------------------*/

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

