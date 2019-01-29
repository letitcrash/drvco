defmodule FootballService.Proto do
  alias FootballService.Proto.Messages.Leagues
  alias FootballService.Proto.Messages.League
  alias FootballService.Proto.Messages.Score
  alias FootballService.Proto.Messages.Scores
  alias FootballService.Proto.Messages.Season
  require Logger

  @moduledoc """
  Recursively transforms given list of maps to Protocol Buffers 
  """

  @doc """
  Entry point to module, accepts only list of leagues, seasons or scores maps.
  Returns binary data encoded in by proto definitions declared in Messages module.
  """
  @spec encode(list(map())) :: {:ok, binary() } | {:error, String.t}
  def encode(list) do
    try do
      list
      |> Enum.map(&from_map(&1))
      |> encode_for_type
    rescue 
      _ ->
        Logger.error("Protobuf encoding error in #{__MODULE__}")
        {:error, "Error encoding to Protobuf struct"} 
    end
  end

  defp encode_for_type([%Score{} = _ | _] = list) do
    scores = Scores.new(scores: list)
    |> Scores.encode()
    {:ok, scores}
  end

  defp encode_for_type([%League{} = _ | _] = list) do
    leagues = Leagues.new(leagues: list)
    |> Leagues.encode()
    {:ok, leagues}
  end

  defp encode_for_type(list), do: list

  defp from_map(%{league: league, seasons: seasons}) do
    League.new(name: league, seasons: encode(seasons))
  end

  defp from_map(%{season: name}) do
    Season.new(name: name)
  end

  defp from_map(map) do
    Score.new(
      home_team: map[:HomeTeam],
      away_team: map[:AwayTeam],
      date: map[:Date],
      ftag: String.to_integer(map[:FTAG]),
      fthg: String.to_integer(map[:FTHG]),
      ftr: map[:FTR],
      htag: String.to_integer(map[:HTAG]),
      hthg: String.to_integer(map[:HTHG]),
      htr: map[:HTR]
    )
  end
end
