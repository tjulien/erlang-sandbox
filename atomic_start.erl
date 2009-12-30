-module(atomic_start).
-export([start/2, wait/0]).

wait() ->
    receive
	die ->
	    void
    end.

start(ProcName, Fun) ->
    Pid = spawn(fun() -> run_or_die(Fun) end),
    try register(ProcName, Pid) of
	true -> Pid ! true
    catch
	error:_ ->
	    Pid ! false
    end.

run_or_die(Fun) ->
    receive 
	true ->
	    Fun(),
	    io:format("~w~n", [registered()]);
	false ->
	    false
    end.

print([]) ->
    io:format("~n");
print([H|T]) ->
	     io:format("~w, ", H),
	     print(T).
	

