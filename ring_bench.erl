-module(ring_bench).
-export([run/2, one_shot/0, passer/1, passer/0]).

%%
% Exercise 8.11 2 a Ring with N nodes, passing a message M Times.
% From Programming Erlang by Joe Armstrong
%%

run(NumNodes, Loops) ->
    Nodes = add_node(NumNodes, [spawn(?MODULE, one_shot, [])]),
    pass(Loops, Nodes).

add_node(0, Pids) -> Pids;

add_node(I, Pids) ->
    [H|_] = Pids,
    add_node(I - 1, [spawn(?MODULE, passer, [H])|Pids]).

passer() ->
    spawn(fun one_shot/0).

passer(Next) ->
    %io:format("waiting to send to ~w...~n", [Next]),
    receive
	send ->
	    io:format("sending to ~w...~n", [Next]),
	    Next ! send,
	    passer(Next);
	exit -> io:format("exiting..."),	    
		Next ! exit
    end.

pass(M, [H|T]) when M > 0 -> H ! send,
		    pass(M - 1, [H,T]);
pass(M, [H|T]) when M =:= 0 -> H ! exit.
		    
    
one_shot() ->
    receive
	_ ->
	    io:format("one shot exiting...~n"),
	    void
    end.
		
