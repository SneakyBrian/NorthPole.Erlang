-module(elf_handler).
-behavior(cowboy_http_handler).
 
-export([init/3]).
-export([handle/2]).
-export([terminate/3]).
 
init(_Type, Req, _Opts) ->
    {ok, Req, undefined_state}.
 
handle(Req, State) ->
        {ok, Body, Req2} = cowboy_req:body(Req),
		% io:format("got body~n"),
        {Method, Req3} = cowboy_req:method(Req2),
		% io:format("got req method~n"),
        {Key, Req4} = cowboy_req:qs_val(<<"key">>, Req3),
		% io:format("got qs key~n"),
        {ok, Req5} = process(Method, Key, Body, Req4),
        {ok, Req5, State}.

process(<<"POST">>, undefined, _, Req) ->
		% io:format("missing key parameter~n"),
        cowboy_req:reply(400, [], <<"Missing key parameter.">>, Req);
process(<<"POST">>, Key, Body, Req) ->
		% io:format("post with key~n"),
		{MegaSecs, Secs, MicroSecs} = now(),
		% io:format("got time~n"),
		Timestamp = MegaSecs * 1000000 * 1000000 + Secs * 1000000 + MicroSecs,
		% io:format("got timestamp~n"),
		Timestampstring = integer_to_list(Timestamp),
		% io:format("got timestamp string ~p~n", [Timestampstring]),	
		Hmacstring = rudolph:generate_hmac(Body, Timestampstring, Key),
		% io:format("got hmac string ~p~n", [Hmacstring]),
		Response = lists:flatten([Timestampstring, $\n, Hmacstring]),
		% io:format("built response ~p~n", [Response]),
		cowboy_req:reply(200, [
                {<<"content-type">>, <<"text/plain; charset=utf-8">>}
        ], Response, Req);
process(_, _, _, Req) ->
        %% Method not allowed.
		% io:format("method not allowed~n"),
        cowboy_req:reply(405, Req).
		
terminate(_Reason, _Req, _State) ->
    ok.
