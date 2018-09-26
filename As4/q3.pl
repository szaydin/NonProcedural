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
