-module(misc).
-export([my_tuple_to_list/1]).
-export([my_time_func/1]).

my_tuple_to_list(T) -> tuple_to_list_helper(T, erlang:size(T), []).

my_time_func(F) ->
    {_, S1, MS1} = erlang:now(),
    F(),
    {_, S2, MS2} = erlang:now(),
    Result = (S2 - S1) + (MS2 - MS1) / 1000.0,
    Result.


tuple_to_list_helper(_, 0, List) -> List;
tuple_to_list_helper(T, N, List) -> tuple_to_list_helper(T, N - 1, List) ++ [erlang:element(N, T)].

