defmodule ApiWeb.LeagueController do
  use ApiWeb, :controller
  alias FootballService.Store

  def index(conn, _params) do
    case Store.list_leagues() do
      {:ok, leagues} ->
        conn
        |> put_status(:ok)
        |> json(leagues)

      {:error, message} ->
        conn
        |> put_status(:not_found)
        |> put_view(ApiWeb.ErrorView)
        |> render("404.json", %{message: message})
    end
  end

  def scores(conn, %{"league" => league, "season" => season}) do
    case Store.get_scores_for(league: league, season: season) do
      {:ok, result} ->
        conn
        |> put_status(:ok)
        |> json(result)

      {:error, message} ->
        conn
        |> put_status(:not_found)
        |> put_view(ApiWeb.ErrorView)
        |> render("404.json", %{message: message}) 
    end
  end
end
