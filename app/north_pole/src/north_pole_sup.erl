-module(north_pole_sup).
-behavior(supervisor).
 
-export([start_link/0]).
-export([init/1]).
 
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).
 
init([]) ->
    {ok, {{one_for_one, 10, 10}, []}}.
