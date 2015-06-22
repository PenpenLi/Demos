-module(day1).
-export([count10/0]).
-export([result/1]).
-export([count_word/1]).
-export([is_a/1]).

count(11) -> ok;
count(N) -> io:format("~p ", [N]), count(N+1).

count10() -> count(1).

result(success) -> io:format("success~n");
result({error, Message}) -> io:format("~p~n", [Message]).

count_word([]) -> 0;
count_word([_|[]]) -> 1;
count_word([32|T]) -> count_word(T) + 1;
count_word([_|T]) -> count_word(T).

is_a(C)->
    if
        C > 96, C < 123 -> true;
        C > 64, C < 89 -> true;
        true -> false
    end.


