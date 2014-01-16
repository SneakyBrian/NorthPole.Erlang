-module(north_pole).
-export([start/0, start/2, stop/0]).

start() ->
    application:start(ranch),
    application:start(cowlib),
    application:start(crypto),
    application:start(cowboy),
    application:start(north_pole).

start(_Type, _Args) ->
    Dispatch = cowboy_router:compile([
		{'_', [
				{"/", cowboy_static, {priv_file, north_pole, "test.html"}},
				{"/elf", elf_handler, []},
				{"/santa", santa_handler, []}
			  ]}		   
    ]),
    cowboy:start_http(my_http_listener, 100,
        [{port, 4242}],
        [{env, [{dispatch, Dispatch}]}]
    ),
    north_pole_sup:start_link().

stop() ->
    application:stop(cowboy).
