-module(server2).
-export([start/2, rpc/2]).

start(Name, Module) ->
    register(Name, spawn(fun() -> loop(Name, Module, Module:init()) end)).

rpc(Name, Request) ->
    Name ! {self(), Request},
    receive
        {Name, ok, Response} -> Response;
        {Name, crash} -> exit(rpc)
    end.

loop(Name, Module, OldState) ->
    receive
        {From, Request} ->
            try Module:handle(Request, OldState) of
                {Response, NewState} ->
                    From ! {Name, ok, Response},
                    loop(Name, Module, NewState)
            catch
                _:Why ->
                    log_the_error(Name, Request, Why),
                    From ! {Name, crash},
                    loop(Name, Module, OldState)
            end
    end.

log_the_error(Name, Request, Why) ->
    io:format("Server ~p request ~p~ncause exception ~p~n", [Name, Request, Why]).

