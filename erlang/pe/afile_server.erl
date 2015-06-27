-module(afile_server).
-export([start/1, loop/1, stop/0]).

start(Dir) -> register(fs, spawn(afile_server, loop, [Dir])).

loop(Dir) ->
    receive
        {Client, ls} ->
            Client ! {self(), file:list_dir(Dir)};
        {Client, {get, File}} ->
            Full = filename:join(Dir, File),
            Client ! {self(), file:read_file(Full)};
        {Client, {put, File, Content}} ->
            Full = filename:join(Dir, File),
            Client ! {self(), file:write_file(Full, Content)}
    end,
    loop(Dir).

stop() -> erlang:exit(erlang:whereis(fs), kill).

