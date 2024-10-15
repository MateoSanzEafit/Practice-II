% Main entry point
main:-
    process,
    halt.

process :-
    case1,
    case2,
    case3.

% Family relations

% Family1
mother(Susana, Magnusen).
sister(Ana, Magnusen).
brother(Carlos, Susana).
cousin(Susana, Simon).
male(Susana).
female(Ana).
male(Carlos).
male(Magnusen).
male(Simon).

% Family2
father(Miguel, Samuel).
grandfather(Cris, Miguel).
grandmother(Sara, Miguel).
uncle(Gustavo, Miguel).
brother(Matias, Gustavo).
brother(Antony, Matias).
male(Miguel).
male(Cris).
female(Sara).
male(Samuel).
male(Gustavo).
male(Matias).
male(Antony).

% Family3
father(Diego, Isabel).
brother(Felipe, Diego).
brother(Gabriel, Felipe).
cousin(Pablo, Diego).
cousin(Sebastian, Diego).
male(Diego).
female(Isabel).
male(Felipe).
male(Gabriel).
male(Pablo).
male(Sebastian).


% Rules for family relationships
father(X,Y):- parent(X, Y), male(X).
mother(X,Y):- parent(X,Y), female(X).
sibling(X,Y):- parent(Z,Y), parent(Z,X), X \= Y.
brother(X,Y):- sibling(X,Y), male(X).
sister(X,Y):- sibling(X,Y), female(X).
grandmother(X,Y):- parent(Z,Y), parent(X,Z), female(X).
grandfather(X,Y):- parent(Z,Y), parent(X,Z), male(X).
uncle(X,Y):- parent(Z,Y), brother(X,Z).
aunt(X,Y):- parent(Z,Y), sister(X,Z).
cousin(X,Y):- uncle(Z,Y), parent(Z,X).
cousin(X,Y):- aunt(Z,Y), parent(Z,X).

% Levels of consanguinity
levelConsanguinity(X, Y, 1) :- father(X, Y).
levelConsanguinity(X, Y, 1) :- mother(X, Y).
levelConsanguinity(X, Y, 1) :- father(Y, X).
levelConsanguinity(X, Y, 1) :- mother(Y, X).

levelConsanguinity(X, Y, 2) :- sibling(X, Y).
levelConsanguinity(X, Y, 2) :- sibling(Y, X).
levelConsanguinity(X, Y, 2) :- grandfather(X, Y).
levelConsanguinity(X, Y, 2) :- grandmother(X, Y).

levelConsanguinity(X, Y, 3) :- uncle(X, Y).
levelConsanguinity(X, Y, 3) :- aunt(X, Y).
levelConsanguinity(X, Y, 3) :- cousin(X, Y).
levelConsanguinity(X, Y, 3) :- cousin(Y, X).

% Inheritance distribution

% Distribute inheritance based on consanguinity levels.
distributeInheritance(Total, Distribution) :-
    findall(Person-Percentage, inheritanceShare(Person, Percentage), Shares),
    adjustPercentages(Shares, Total, Distribution).

% Calculate inheritance share based on level of consanguinity
inheritanceShare(Person, Percentage) :-
    levelConsanguinity(Person, _, 1), Percentage is 30.
inheritanceShare(Person, Percentage) :-
    levelConsanguinity(Person, _, 2), Percentage is 20.
inheritanceShare(Person, Percentage) :-
    levelConsanguinity(Person, _, 3), Percentage is 10.

% Adjust percentages so that they sum up to 100%
adjustPercentages(Shares, Total, Distribution) :-
    sumPercentages(Shares, Sum),
    (Sum > 100 ->
        ScaleFactor is 100 / Sum,
        scalePercentages(Shares, ScaleFactor, Distribution)
    ;
        Distribution = Shares
    ).

% Sum all the percentages
sumPercentages([], 0).
sumPercentages([_-P|T], Sum) :-
    sumPercentages(T, Rest),
    Sum is P + Rest.

% Scale percentages to ensure they sum up to 100%
scalePercentages([], _, []).
scalePercentages([Person-P|T], ScaleFactor, [Person-NewP|Rest]) :-
    NewP is P * ScaleFactor,
    scalePercentages(T, ScaleFactor, Rest).

% Print the results: Person, Percentage, and the amount of money
printDistribution([], _).
printDistribution([Person-Percentage|T], Total) :-
    Amount is (Percentage / 100) * Total,
    format('~w obtiene un ~2f%% de la herencia que representa $~2f~n', [Person, Percentage, Amount]),
    printDistribution(T, Total).

% Case 1: Inheritance of $100,000 with 2 children, 1 sibling, 1 cousin
case1 :-
    write('Case 1: Inheritance of $100,000'), nl,
    distributeInheritance(100000, Distribution),
    printDistribution(Distribution, 100000).

% Case 2: Inheritance of $250,000 with 1 son, 2 grandparents, 3 uncles
case2 :-
    write('Case 2: Inheritance of $250,000'), nl,
    distributeInheritance(250000, Distribution),
    printDistribution(Distribution, 250000).

% Case 3: Inheritance of $150,000 with 1 daughter, 2 brothers, 2 cousins
case3 :-
    write('Case 3: Inheritance of $150,000'), nl,
    distributeInheritance(150000, Distribution),
    printDistribution(Distribution, 150000).

% Start program
:- main.