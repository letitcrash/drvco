defmodule ApiWeb.LeagueController do
  use ApiWeb, :controller

  def index(conn, _params) do
    json conn, FootballService.Store.list_leagues_and_seasons
  end

  def show(conn, %{"id" => _id}) do
    json conn, []
  end

  def show_season(conn, %{"id" => id, "league_id" => league_id}) do
    json conn, FootballService.Store.get_match_stats_for(league: league_id, season: id)
  end
end
