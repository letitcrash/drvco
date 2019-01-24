defmodule ApiWeb.LeagueControllerTest do
  use ApiWeb.ConnCase
  alias FootballService.Store

  @league "SP1"
  @season "201617"

  @invalid_league "XX1"
  @invalid_season "201819"

  describe "league api tests" do
    test "render leagues and seasons list when data valid", %{conn: conn} do
      conn = get(conn, Routes.league_path(conn, :index))
      {:ok, leagues } = Store.list_leagues

      expected =
        leagues
        |> Jason.encode!
        |> Jason.decode!

      assert json_response(conn, 200) == expected
    end

    test "match stats", %{conn: conn} do
      conn = get(conn, Routes.league_path(conn, :scores, @league, @season))
      {:ok, scores} = Store.get_scores_for(league: @league, season: @season)

      expected = 
        scores 
        |> Jason.encode!
        |> Jason.decode!

      assert json_response(conn, 200) == expected
    end

    test "invalid scores json", %{conn: conn} do
      conn = get(conn, Routes.league_path(conn, :scores, @invalid_league, @invalid_season))
      {:error, message} = Store.get_scores_for(league: @invalid_league, season: @invalid_season)
      
      assert json_response(conn, 404) == %{"errors" => %{"detail" => message}}
    end
  end
end
