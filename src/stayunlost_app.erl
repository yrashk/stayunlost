-module(stayunlost_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    {ok, Port} = application:get_env(stayunlost, port),
    Dispatch = [{'_', [{'_', stayunlost_http_handler, []}]}],
    {ok, Listener} = cowboy:start_listener(http, 100,
                                           cowboy_tcp_transport, [{port, Port}],
                                           cowboy_http_protocol, [{dispatch, Dispatch}]),
    {ok, Pid} = stayunlost_sup:start_link(),
    {ok, Pid, Listener}.

stop(Listener) ->
    cowboy:stop_listener(Listener),
    ok.
