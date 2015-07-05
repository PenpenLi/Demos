-module(server3).
-export([start/2, rpc/2, swap_code/2]).

start(Name, Module) ->
    register(Name, spawn(fun() -> loop(Name, Module, Module:init()) end)).

rpc(Name, Request) ->
    Name ! {self(), Request},
    receive
        {Name, Response} -> Response
    end.

loop(Name, Module, OldState) ->
    receive
        {From, {swap_code, NewModule}} ->
            From ! {Name, ack},
            loop(Name, NewModule, OldState);
        {From, Request} ->
            {Response, NewState} = Module:handle(Request, OldState),
            From ! {Name, Response},
            loop(Name, Module, NewState)
    end.

swap_code(Name, Module) -> rpc(Name, {swap_code, Module}).

