-module(new_name_server).
-export([init/0, add/2, all_names/0, delete/1, find/1, handle/2]).
-import(server3, [rpc/2]).

all_names() -> rpc(name_server, all_names).
add(Name, Place) -> rpc(name_server, {add, Name, Place}).
delete(Name) -> rpc(name_server, {delete, Name}).
find(Name) -> rpc(name_server, {find, Name}).

init() -> dict:new().

handle({add, Name, Place}, Dict) -> {ok, dict:store(Name, Place, Dict), Dict};
handle({delete, Name}, Dict) -> {ok, dict:erase(Name, Dict), Dict};
handle({find, Name}, Dict) -> {dict:find(Name, Dict), Dict};
handle(all_names, Dict) -> {dict:fetch_keys(Dict), Dict}.
