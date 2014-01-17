-module(santa_handler).
-behavior(cowboy_http_handler).
 
-export([init/3]).
-export([handle/2]).
-export([terminate/3]).
 
init(_Type, Req, _Opts) ->
    {ok, Req, undefined_state}.
 
handle(Req, State) ->
		% io:format("santa_handler~n"),
        {ok, Body, Req2} = cowboy_req:body(Req),
		% io:format("got body ~p~n", [Body]),
        {Method, Req3} = cowboy_req:method(Req2),
		% io:format("got req method ~p~n", [Method]),
        {Key, Req4} = cowboy_req:qs_val(<<"key">>, Req3),
		% io:format("got qs key ~p~n", [Key]),
        {Timestamp, Req5} = cowboy_req:qs_val(<<"timestamp">>, Req4),
		% io:format("got qs timestamp ~p~n", [Timestamp]),
        {Hmac, Req6} = cowboy_req:qs_val(<<"hmac">>, Req5),
		% io:format("got qs hmac ~p~n", [Hmac]),
        {ok, Req7} = process(Method, Key, Timestamp, Hmac, Body, Req6),
        {ok, Req7, State}.

process(<<"POST">>, undefined, _, _, _, Req) ->
		% io:format("missing key parameter~n"),
        cowboy_req:reply(400, [], <<"Missing key parameter.">>, Req);
process(<<"POST">>, _, undefined, _, _, Req) ->
		% io:format("missing timestamp parameter~n"),
        cowboy_req:reply(400, [], <<"Missing timestamp parameter.">>, Req);
process(<<"POST">>, _, _, undefined, _, Req) ->
		% io:format("missing hmac parameter~n"),
        cowboy_req:reply(400, [], <<"Missing hmac parameter.">>, Req);
process(<<"POST">>, Key, Timestamp, Hmac, Body, Req) ->
		% io:format("post with key~n"),		
		OldEnough = is_old_enough(Timestamp),
		Response = 	if
						OldEnough ->
							% io:format("old enough~n"),
							Hmacstring = binary_to_list(Hmac),
							% io:format("got hmac ~p~n", [Hmacstring]),
							Hmacstring2 = rudolph:generate_hmac(Body, binary_to_list(Timestamp), Key),
							% io:format("got hmac2 ~p~n", [Hmacstring2]),
							if
								Hmacstring =:= Hmacstring2 -> "NICE";
								true -> "NAUGHTY"
							end;
						true -> "NOTREADY"
					end,
		% io:format("built response ~p~n", [Response]),
		cowboy_req:reply(200, [
                {<<"content-type">>, <<"text/plain; charset=utf-8">>}
        ], Response, Req);
process(_, _, _, _, _, Req) ->
        %% Method not allowed.
		% io:format("method not allowed~n"),
        cowboy_req:reply(405, Req).

is_old_enough(Timestamp) ->
		{MegaSecs, Secs, MicroSecs} = now(),
		% io:format("got time~n"),
		NowTimestamp = MegaSecs * 1000000 * 1000000 + Secs * 1000000 + MicroSecs,
		% io:format("got NowTimestamp~n"),
		Diff = NowTimestamp - list_to_integer(binary_to_list(Timestamp)),
		if
			Diff > 5 * 1000000 -> % 5 seconds
				true;
			true -> % works as an 'else' branch
				false
		end.

terminate(_Reason, _Req, _State) ->
    ok.
