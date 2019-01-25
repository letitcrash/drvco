defmodule ApiWeb.LeagueControllerTest do
  use ApiWeb.ConnCase
  import ProtoResponse
  alias FootballService.Store
  alias FootballService.Proto.Messages.Leagues
  alias FootballService.Proto.Messages.Scores

  @league "SP1"
  @season "201617"
  @unavailable_league "XX1"
  @unavailable_season "201819"

  describe "league api tests" do
    test "render leagues and seasons list when data valid", %{conn: conn} do
      conn = get(conn, Routes.league_path(conn, :index))
      {:ok, leagues} = Store.list_leagues()

      expected =
        leagues
        |> Jason.encode!()
        |> Jason.decode!()

      assert json_response(conn, 200) == expected
    end

    test "scores", %{conn: conn} do
      conn = get(conn, Routes.league_path(conn, :scores, @league, @season))
      {:ok, scores} = Store.get_scores(@league, @season, format: :json)

      expected =
        scores
        |> Jason.encode!()
        |> Jason.decode!()

      assert json_response(conn, 200) == expected
    end

    test "unavailable leagues and season scores json", %{conn: conn} do
      conn =
        get(conn, Routes.league_path(conn, :scores, @unavailable_league, @unavailable_season))

      {:error, message} =
        Store.get_scores(@unavailable_league, @unavailable_season, format: :json)

      assert json_response(conn, 404) == %{"errors" => %{"detail" => message}}
    end

    test "ensure protobuf leagues", %{conn: conn} do
      conn = get(conn, Routes.protobuf_path(conn, :index))
      {:ok, leagues} = Store.list_leagues(format: :proto)
      expected = Leagues.decode(leagues)

      assert proto_response(conn, 200, Leagues) == expected
    end

    test "ensure protobuf scores", %{conn: conn} do
      conn = get(conn, Routes.protobuf_path(conn, :scores, @league, @season))
      {:ok, bin} = Store.get_scores(@league, @season, format: :proto)

      expected = Scores.decode(bin)

      assert proto_response(conn, 200, Scores) == expected
    end
  end
end
