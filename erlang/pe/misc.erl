-module(misc).
-export([my_tuple_to_list/1]).

my_tuple_to_list(T) -> tuple_to_list_helper(T, erlang:size(T), []).

tuple_to_list_helper(_, 0, List) -> List;
tuple_to_list_helper(T, N, List) -> tuple_to_list_helper(T, N - 1, List) ++ [erlang:element(N, T)].

