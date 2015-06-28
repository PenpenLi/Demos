-module(afile_client).
-export([ls/0, get/1, put/2]).

ls() ->
    fs ! {self(), ls},
    FS = whereis(fs),
    receive
        {FS, FileList} ->
            FileList
    end.

get(File) ->
    fs ! {self(), {get, File}},
    FS = whereis(fs),
    receive
        {FS, Content} ->
            Content
    end.

put(File, Content) ->
    fs ! {self(), {put, File, Content}},
    FS = whereis(fs),
    receive {FS, Result} -> Result
    end.

