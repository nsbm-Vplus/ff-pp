/* age & horoscope.pro
  age and horoscope identification game.  

    start with ?- go.     */

go :- addinfo, write('Player(s) Details :'), 
	nl,
	generate.

:- dynamic player(Name,Y,M,D).

addinfo :-
	write('player '),
	getcount(C),
	write(C),
	nl,
	write('Please Enter Player Name : '),
	read(Name), nl,
	verifyDOB(Y,M,D),
	assert(player(Name,Y,M,D)),
	continue.

getcount(Count) :- aggregate_all(count,player(_,_,_,_), Count).

verifyDOB(Y,M,D) :- 
	getBirthYear(Y),
	getBirthMonth(M),
	getBirthDate(D),
	nl.
	
getBirthYear(Y) :-
	write('Enter Birth Year(YYYY) : '),
	read(Year),
	(integer(Year) -> (Year > 1000 -> (Y = Year);write('*Please Enter Year Above 1000'),nl,(getBirthYear(Y))); (getBirthYear(Y))).
	
getBirthMonth(M) :-
	write('Enter Birth Month(MM) : '),
	read(Month),
	(integer(Month) -> (between(1,12,Month) -> (M = Month);write('*Please Enter Month Between 1-12'),nl,(getBirthMonth(M))); (getBirthMonth(M))).
	
getBirthDate(D) :-
	write('Enter Birth Date(DD) : '),
	read(Date),
	(integer(Date) -> (between(1,31,Date) -> (D = Date);write('*Please Enter Date Between 1-31'),nl,(getBirthDate(D))); (getBirthDate(D))).

continue :- 
	write('Do you want to continue ? (Y/N) : '),
	read(Term),
    (Term == 'y' -> addinfo, !;
    (Term == 'n' -> !, !;
    (continue))).

generate :- nl,
	getcount(C),
	(C >= 1 -> 
	retract(player(Name,Y,M,D)),
	write(Name),
	write(' DOB: ' + Y  + M +  D),
	generate;
	(nl,write('End'))).
	
