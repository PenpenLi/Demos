-module(day3).
-export([translate_server/0, translate/2, translate_server_monitor/0, start_trans_server/0, stop_trans_server/0]).

translate_server() ->
    receive
        {From, "one"} ->
            From ! 1,
            translate_server();
        {From, "two"} ->
            From ! 2,
            translate_server();
        {From, _} ->
            From ! "I don't understand.",
            translate_server()
    end.

translate(To, Word) ->
    To ! {self(), Word},
    receive
        Result -> Result
    end.

translate_server_monitor() ->
    process_flag(trap_exit, true),
    receive
        new  ->
            io:format("Create translate server and monitoring process.~n"),
            register(translator, spawn_link(fun day3:translate_server/0)),
            translate_server_monitor();
        {'EXIT', From, Reason} ->
            io:format("Translator ~p died with reason ~p,", [From, Reason]),
            io:format(" restarting ...~n"),
            self() ! new,
            translate_server_monitor()
    end.

start_trans_server() ->
    register(tsm, spawn(fun day3:translate_server_monitor/0)),
    tsm ! new.

stop_trans_server() ->
    erlang:exit(erlang:whereis(tsm), kill),
    erlang:exit(erlang:whereis(translator), kill).
