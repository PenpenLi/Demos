-module(day2).
-export([get_value/2]).
-export([test/0]).
-export([calc_total/1]).

get_value(M, K) ->
    {K, V} = M, V.

test() ->
    "Hello" = get_value({msg, "Hello"}, msg),
    ok.

calc_total(ItemList) ->
    [{Name, Price * Count} || {Name, Count, Price} <- ItemList].

