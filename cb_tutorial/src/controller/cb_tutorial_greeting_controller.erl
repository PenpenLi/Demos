-module(cb_tutorial_greeting_controller, [Req]).
-compile(export_all).

hello('GET', []) ->
    {output, "Hello World!"}.

hello_json('GET', []) ->
    {json, [{result, [{hello, "Hello World!"}, {"xx", "Test"}, {num, 1}, {array, [1,2,3,4]}]}]}.

hello_template('GET', []) ->
    {ok, [{hello, "Hello Templates"}]}.

list('GET', []) ->
    io:format("GET greeting list ...~n"),
    Greetings = boss_db:find(greeting, []),
    io:format("greetings: ~p~n", [Greetings]),
    {ok, [{list, Greetings}]}.

create('GET', []) -> ok;
create('POST', []) ->
    GreetingText = Req:post_param("greeting_text"),
    NewGreeting = greeting:new(id, GreetingText),
    case NewGreeting:save() of
        {ok, SavedGreeting} ->
            io:format("greeting saved: ~p~n", [SavedGreeting]),
            {redirect, [{action, "list"}]};
        {error, ErrorList} ->
            {ok, [{errors, ErrorList}, {new_msg, NewGreeting}]}
    end.

delete('POST', []) ->
    boss_db:delete(Req:post_param("greeting_id")),
    {redirect, [{action, "list"}]}.

test_message('GET', []) ->
    TestMessage = "Hello!",
    boss_mq:push("test-message", TestMessage),
    {output, TestMessage}.

pull('GET', [LastTimestamp]) ->
    {ok, Timestamp, Greetings} = boss_mq:pull("new-greetings", list_to_integer(LastTimestamp)),
    {json, [{timestamp, Timestamp}, {greetings, Greetings}]}.

live('GET', []) ->
    Greetings = boss_db:find(greeting, []),
    Timestamp = boss_mq:now("new-greetings"),
    {ok, [{greetings, Greetings}, {timestamp, Timestamp}]}.

