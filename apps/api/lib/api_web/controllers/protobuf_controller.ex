defmodule ApiWeb.ProtobufController do
  use ApiWeb, :controller
  alias FootballService.Store

  def index(conn, _params) do
    case Store.list_leagues(format: :proto) do
      {:ok, leagues} ->
        conn
        |> put_resp_header("content-type", "application/x-protobuf")
        |> send_resp(200, leagues)
        |> halt()

      {:error, message} ->
        conn
        |> put_status(:not_found)
        |> put_view(ApiWeb.ErrorView)
        |> render("404.json", %{message: message})
    end
  end

  def scores(conn, %{"league" => league, "season" => season}) do
    case Store.get_scores(league, season, format: :proto) do
      {:ok, bin} ->
        conn
        |> put_resp_header("content-type", "application/x-protobuf")
        |> send_resp(200, bin)
        |> halt()

      {:error, message} ->
        conn
        |> put_status(:not_found)
        |> put_view(ApiWeb.ErrorView)
        |> render("404.json", %{message: message})
    end
  end
end
