-module(stayunlost_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, Port} = application:get_env(stayunlost, port),
    Dispatch = {'_', [{'_', stayunlost_http_handler, []}]},
    {ok, { {one_for_one, 5, 10}, [
                                  {stayunlost_http_server, {cowboy, start_listener, [http, 100, 
                                                                                     cowboy_tcp_transport, [{port, Port}],
                                                                                     cowboy_http_protocol, [{dispatch, Dispatch}]]},
                                   permanent, infinity, supervisor, [stayunlost_http_handler, cowboy, cowboy_http_protocol, cowboy_tcp_transport]}
                                 ]} }.

