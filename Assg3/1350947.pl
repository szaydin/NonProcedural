% Sumeyye Aydin , 1350947
% Cmput 325
% Assignment 3

/* --------------
Question 1
Define a predicate
setUnion(+S1,+S2,-S3)
where S1 and S2 are lists of atoms, and S3 represents the union of S1 and S2.  E.g.
?- setUnion([a,b,c],[b,a,c,e],S).
S=[a,b,c,e].
Assume S1 and S2 do not contain duplicates. It is required that the union does not contain repeated elements either. 
 -------------- */

%Finding if it is a member or not
xmember(X,[X|_]).
xmember(X,[H|T]) :- xmember(X,H); xmember(X,T).

setUnion([],X,X).
setUnion([X|R],Y,Z) :- xmember(X,Y), !, setUnion(R,Y,Z).
setUnion([X|R],Y,[X|Z]) :- setUnion(R,Y,Z).

/* --------------
Question 2
Define a predicate
swap(+L, -R)
where L is a list of elements and R is a list where the 1st two elements in L are swapped positions, so are the next two elements, and so on. If the number of elements in L is odd, then the last element is left as is. E.g,a
 ------------- */

swap([],[]).
swap([A], [A]).
swap([A, B|L], [B, A|R]):- swap(L,R).

/* -----------------
Question 3
Define a predicate
largest(+L,-N)
where L is a possibly nested list of numbers and N is the largest among them. We assume L is non-empty and it does not contain any empty sublists, either. E.g.
 --------------- */

%I used flatten function that we used in the class.
max_n([R], R).
max_n([X|Xs], R):- max_n(Xs, T), (X > T -> R = X ; R = T).

largest(L,N):- flatten(L,F), max_n(F,N).

/* -----------------
Question 4
 Define a predicate

countAll(+L,-N)

such that given a flat list L of atoms, the number of occurrences of every atom is counted. Thus, N should be a list of pairs [a,n] representing that atom a occurs in L n times. These pairs should appear in a non-increasing order. E.g

 -------------- */

%I used a code from website for sort algorithm and I stated the link below.
addi([], A, [[A,1]]).
addi([[H,X]|T], H, [[H,X1]|T]) :- X1 is X + 1.
addi([[H,X]|T], A, [[H,X]|R]) :- H \= A, addi(T, A, R).

countAll([], []).
countAll([H|T], R) :- countAll(T, Temp), addi(Temp, H, K), merge_sort(K,  R), !.

/* --------------------
Question 5

Define a predicate
sub(+L,+S,-L1)
where L is a possibly nested list of atoms, S is a list of pairs in the form [[x1,e1],...,[xn,en]], and L1 is the same as L except that any occurrence of xi is replaced by ei. Assume xi's are atoms and ei's are arbitrary expressions. E.g.
?- sub([a,[a,d],[e,a]],[[a,2]],L).
L= [2,[2,d],[e,2]].
Note: S is intended as a substitution. In this case, xi's are distinct, and they do not occur in ei's.
 --------------------------*/

%I implemented this but unfortunately cannot handle nested list right now.
sub( [] , _ , [] ) .
sub( [W|Ws] , Map , [R|Rs] ) :- transform( W , Map , R ) , sub( Ws , Map , Rs ).

transform( X , M , Y ) :- ( member( [X,Y] , M ) -> true ; X=Y ) .

/* -----------------------
Question 6

:- dynamic c325/8.
:- dynamic setup/4.

insert_data :-
assert(c325(fall_2010,john,14,13,15,10,76,87)),
assert(c325(fall_2010,lily, 9,12,14,14,76,92)),
assert(c325(fall_2010,peter,8,13,12,9,56,58)),
assert(c325(fall_2010,ann,14,15,15,14,76,95)),
assert(c325(fall_2010,ken,11,12,13,14,54,87)),
assert(c325(fall_2010,kris,13,10,9,7,60,80)),
assert(c325(fall_2010,audrey,10,13,15,11,70,80)),
assert(c325(fall_2010,randy,14,13,11,9,67,76)),
assert(c325(fall_2010,david,15,15,11,12,66,76)),
assert(c325(fall_2010,sam,10,13,10,15,65,67)),
assert(c325(fall_2010,kim,14,13,12,11,68,78)),

assert(setup(fall_2010,as1,15,0.1)),
assert(setup(fall_2010,as2,15,0.1)),
assert(setup(fall_2010,as3,15,0.1)),
assert(setup(fall_2010,as4,15,0.1)),
assert(setup(fall_2010,midterm,80,0.25)),
assert(setup(fall_2010,final,100,0.35)).

% query1



% --------Help Functions----------
%Fetched from eclass or internet

% I get the idea from http://kti.mff.cuni.cz/~bartak/prolog/sorting.html
% Instead of doing in a list, I change it to 2nd element of sublist

halve(L, A, B) :- hv(L, [], A, B).
hv(L, L, [], L). % for lists of even length
hv(L, [_|L], [], L).
hv([H|T], Acc, [H|L], B) :- !, hv(T, [_|Acc], L, B).

merge_sort([], []).
merge_sort([X], [X]).
merge_sort(L, S) :- L = [_, _ | _], halve(L, L1, L2), !, merge_sort(L1, S1), merge_sort(L2, S2), merge(S1, S2, S).

merge([], L, L).
merge(L, [], L) :- !, L \= [].
merge([[X1, K1]|T1], [[X2, K2]|T2], [[X1, K1]|T]) :- K1 >= K2, !, merge(T1, [[X2, K2]|T2], T).
merge([[X1, K1]|T1], [[X2, K2]|T2], [[X2, K2]|T]) :- K1 =< K2, !, merge([[X1, K1]|T1], T2, T).

% I get this from eclass and examples

flatten([],[]).
flatten([A|L],[A|L1]) :- xatom(A), flatten(L,L1).
flatten([A|L],R) :- flatten(A,A1), flatten(L,L1), append(A1,L1,R).

xatom(A) :- atom(A).
xatom(A) :- number(A).



