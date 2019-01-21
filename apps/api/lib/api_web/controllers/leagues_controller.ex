defmodule ApiWeb.LeagueController do
  use ApiWeb, :controller

  def index(conn, _params) do
    json conn, FootballService.Store.list_leagues_and_seasons
  end
end
