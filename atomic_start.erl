-module(atomic_start).
-export([start/2]).

%%
% Exercise 8.11 1. from Programming Erlang by Joe Armstrong
% spawns Fun and registers it under name ProcName atomically
%%

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
	    Fun();
	    %io:format("~w~n", [registered()]);
	false ->
	    false
    end.

