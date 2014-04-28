/* age & horoscope.pro
  age and horoscope identification game.  

    start with ?- go.     */

go :- addinfo, write('Player(s) Details :'), nl,nl,
	write('[Name DOB Age Horoscope]'),nl,
	find,nl,
	write('Do you want to clear Database ? (y/n): '),
	read(Ans),
	(Ans == 'y' -> generate,!; (nl,write('You can add more players later !'))).
	

:- dynamic player/4.

addinfo :-
	write('player '),
	getcount(C),
	write(C),
	nl,
	write('Please Enter Player Name : '),
	read(Name),nl,
	verifyDOB(Y,M,D),
	zodiac_sign(Sign,M,D),
	find_age(Y,M,Age),
	assert(player(Name,dob(Y,M,D),Age,Sign)),
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
	write('Do you want to continue ? (y/n) : '),
	read(Term),
    (Term == 'y' -> addinfo, !;
    (Term == 'n' -> !, !;
    (continue))).
	
find_age(Y,M,Age) :- 
	get_date_time_value(year, Year),
	get_date_time_value(month, Month),
	((Month >= M) -> Age is Year-Y; Age is Year-Y-1).
	
	
/* Predicate to get Date components
	Key- date, day, year, month | Value- Return value from the predicate */	
get_date_time_value(Key, Value) :-
    get_time(Stamp),
    stamp_date_time(Stamp, DateTime, local),
    date_time_value(Key, DateTime, Value).	
	
zodiac_sign(Sign,M,D) :-
	(((M == 12, D >= 22);(M == 1, D =< 19)) -> Sign = 'Capricorn'; !),
	(((M == 1, D >= 20); (M == 2, D =< 18)) -> Sign = 'Aquarius'; !),
	(((M == 2, D >= 19); (M == 3, D =< 20)) -> Sign = 'Pisces'; !),
	(((M == 3, D >= 21); (M == 4, D =< 19)) -> Sign = 'Aries'; !),
	(((M == 4, D >= 20); (M == 5, D =< 20)) -> Sign = 'Taurus'; !),
	(((M == 5, D >= 21); (M == 6, D =< 20)) -> Sign = 'Gemini'; !),
	(((M == 6, D >= 21); (M == 7, D =< 22)) -> Sign = 'Cancer'; !),
	(((M == 7, D >= 23); (M == 8, D =< 22)) -> Sign = 'Leo'; !),
	(((M == 8, D >= 23); (M == 9, D =< 22)) -> Sign = 'Virgo'; !),
	(((M == 9, D >= 23); (M == 10, D =< 22)) -> Sign = 'Libra'; !),
	(((M == 10, D >= 23); (M == 11, D =< 21)) -> Sign = 'Scorpio'; !),
	(((M == 11, D >= 22); (M == 12, D =< 21)) -> Sign = 'Sagittarius'; !).

/* Clear Database */
generate :- nl,
	getcount(C),
	(C >= 1 -> 
	retract(player(Name,DOB,Age,Sign)),
	write('Database Content >>>'),
	write('Player Name : '),
	write(Name),
	write(' '),
	write(DOB),
	write(' Age: '),
	write(Age),
	write(' Horoscope: '),
	write(Sign),
	generate;
	(nl,write('End'))).
	
/* Sort List Using setof - Remove duplicates*/
sort_set :-
	setof([Name,DOB,Age,Sign],[Name,DOB,Sign]^player(Name,DOB,Age,Sign),List),
	print_all2(List).

/* Sort List using keysort built in predicate and remove keys using library(pairs) */
find :-
	findall(Age-[Name,DOB,Age,Sign],player(Name,DOB,Age,Sign),List),
	keysort(List,SList),
	use_module(library(pairs)),
	pairs_values(SList,SortedList),
	print_all2(SortedList).
	
/* Print Lists*/

print_all([X|Rest]) :- write(X), nl, print_all(Rest).

print_all2(List) :- foreach(member(X,List),(write(X),nl)).
