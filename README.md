# NorthPole.Erlang #

## A HTTP Post Data Signing and Verification Service, written in Erlang ##

NorthPole.Erlang provides 2 HTTP end points that accept any arbitrary POST data.

`/elf` is the end point that signs the data with a timestamp and a HMAC

`/santa` is the end point that verifies the values returned by `/elf`

`/santa` responds with:

- `NICE` if the POST data is verified successfully
- `NAUGHTY` if the POST data HMAC does not match the specified HMAC
- `NOTREADY` if the timestamp is too soon, i.e. is not older than the minimum age

The service has 2 configuration items:

1. A minimum age that the timestamps must be before they will pass verification by `/santa`
2. A super secret key that is combined with the user-specified key in order to generate the HMAC

See `test.html` for example usage.

This is a port of the ASP.NET project [NorthPole](https://github.com/SneakyBrian/NorthPole).

## Quickstart ##

* If you already have *make*, *rebar* and *git* in your path (even on windows), from within the top level folder run the following commands:
    * make (will download dependencies and build everything)
	* launch (will initialise the runtime environment and start the application)
    * available at http://localhost:4242/


