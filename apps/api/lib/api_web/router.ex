defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiWeb do
    pipe_through :api

    get "/leagues", LeagueController, :index
    get "/leagues/:league/seasons/:season/scores", LeagueController, :scores
    get "/proto/leagues", ProtobufController, :index
    get "/proto/:league/:season", ProtobufController, :scores
  end
end
