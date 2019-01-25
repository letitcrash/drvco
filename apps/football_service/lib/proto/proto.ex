defmodule FootballService.Proto do
  alias FootballService.Proto.Messages.Leagues
  alias FootballService.Proto.Messages.League
  alias FootballService.Proto.Messages.Score
  alias FootballService.Proto.Messages.Scores
  alias FootballService.Proto.Messages.Season

  def encode(list) do
    list
    |> Enum.map(&from_map(&1))
    |> encode_for_type
  end

  def encode_for_type([%Score{} = _ | _] = list) do
    Scores.new(scores: list) 
    |> Scores.encode
  end
  
  def encode_for_type([%League{} = _ | _] = list) do
    Leagues.new(leagues: list) 
    |> Leagues.encode
  end

  def encode_for_type(list), do: list
  
  def from_map(%{league: league, seasons: seasons}) do
    League.new(name: league, seasons: encode(seasons))
  end

  def from_map(%{season: name}) do
    Season.new(name: name)
  end
  
  def from_map(map) do
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
