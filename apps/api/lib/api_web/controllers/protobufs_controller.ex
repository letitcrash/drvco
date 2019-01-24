defmodule ApiWeb.ProtobufsController do
  use ApiWeb, :controller
  alias FootballService.Store

  def index(conn, %{"league_id" => league_id, "season_id" => season_id}) do
    with {:ok, [result | _rest]} <- Store.get_match_stats_for(league: league_id, season: season_id) 
    do
      protobuf = ApiWeb.Protobufs.Match.new(
        league: league_id,
        season: season_id,
        game_date: result[:Date],
        home_team: result[:HomeTeam]
       # away_team: result.away_team,
       # fthg: result.fthg,
       # ftag: result.ftag,
       # ftr: result.ftr,
       # hthg: result.hthg,
       # htag: result.htag,
       # htr: result.htr
      )
      resp = ApiWeb.Protobufs.Match.encode(protobuf)

      conn
      |> put_resp_header("content-type", "application/octet-stream")
      |> send_resp(200, resp)
    end
  end
end

