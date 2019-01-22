defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiWeb do
    pipe_through :api

    get "/leagues", LeagueController, :index
    get "/leagues/:id", LeagueController, :show
    get "/leagues/:league_id/seasons/:id", LeagueController, :show_season
  end
end
