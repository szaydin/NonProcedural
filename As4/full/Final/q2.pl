:- use_module(library(clpfd)).
:- use_module(library(lists)).

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
