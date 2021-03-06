-module(stayunlost_http_handler).
-behaviour(cowboy_http_handler).

-export([init/3, handle/2, terminate/2]).

init({tcp, http}, Req, _Opts) ->
    {ok, Req, undefined}.

handle(Req, State) ->
    {ok, Req2} = cowboy_http_req:reply(200, [], "Hello World!", Req),
    {ok, Req2, State}.

terminate(Req, State) ->
    ok.
