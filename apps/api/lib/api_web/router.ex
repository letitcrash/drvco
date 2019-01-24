defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiWeb do
    pipe_through :api

    get "/leagues", LeagueController, :index
    get "/leagues/:league/seasons/:season/scores", LeagueController, :scores
    get "/proto/:league_id/:season_id", ProtobufsController, :index
  end
end
