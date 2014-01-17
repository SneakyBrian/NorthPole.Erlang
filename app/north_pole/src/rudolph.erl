-module(rudolph).
-export([generate_hmac/3]).

generate_hmac(Body, Timestamp, Key) ->
		SuperKey = [Key, <<"this is my super secret key - shhh, don't tell anyone!">>],
		% io:format("built superkey ~p~n", [SuperKey]),
		% io:format("got timestamp string ~p~n", [Timestamp]),
		BodyWithTimestamp = lists:flatten([Body, $\n, Timestamp]),
		% io:format("added timestamp to body ~p~n", [BodyWithTimestamp]),
		Hmac = crypto:hmac(sha, SuperKey, BodyWithTimestamp),
		binary_to_list(base64:encode(Hmac)).