flatten([],[]).
flatten([A|L],[A|L1]) :- xatom(A), flatten(L,L1).
flatten([A|L],R) :- flatten(A,A1), flatten(L,L1), append(A1,L1,R).

xatom(A) :- atom(A).
xatom(A) :- number(A).

max_n([R], R).
max_n([X|Xs], R):- max_n(Xs, T), (X > T -> R = X ; R = T).

largest(L,N):- flatten(L,F), max_n(F,N).
