defmodule FootballService.Store do
  use GenServer
  alias FootballService.CSVParser
  alias FootballService.ProtoMessages.Leagues
  alias FootballService.ProtoMessages.League
  alias FootballService.ProtoMessages.Score
  alias FootballService.ProtoMessages.Scores
  alias FootballService.ProtoMessages.Season
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :store)
  end

  def init(_) do
    {:ok, CSVParser.init}
  end

  def list_leagues(opts \\ []) do
    format = Keyword.get(opts, :format)
    GenServer.call(:store, {:list_leagues, format})
  end

  def get_scores(league, season, opts \\ []) do
    format = Keyword.get(opts, :format)
    GenServer.call(:store, {:get_scores, league, season, format })
  end

  def encode_in(list, _format) when is_nil(list), do: raise "League or Season is not available"
  def encode_in(list, format) when is_nil(format), do: list
  def encode_in(list, :json) when is_list(list), do: transform_to_json(list)
  def encode_in(list, :proto) when is_list(list), do: transform_to_protobuf(list)
  def encode_in(_list, _format), do: raise "Unsupported format"

  def transform_to_json(list) do
    list
  end

  def transform_to_protobuf(list) do
    list
    |> Enum.map(&from_map(&1))
    |> encode
  end

  def encode([%Score{} = _f | _] = list) do
    Scores.new(scores: list) 
    |> Scores.encode
  end
  
  def encode([%League{} = _f | _] = list) do
    Leagues.new(leagues: list) 
    |> Leagues.encode
  end

  def encode(list), do: list
  
  def from_map(%{league: league, seasons: seasons}) do
    League.new(name: league, seasons: transform_to_protobuf(seasons))
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

  def make(list) do
    list
    |> Map.keys
    |> Enum.map(fn i -> %{season: i} end)
  end

  #Callbacks

  # List leagues
  def handle_call({:list_leagues, format}, _from, state) do
    try do
      result =
        state
        |> Map.keys
        |> Enum.map(fn league -> %{league: league, seasons: make(state[league])} end)
        |> encode_in(format)

      {:reply, {:ok, result}, state}
    rescue 
      e ->
        IO.puts(e)
        {:reply, {:error, e.message}, state}
    end
  end

  #Get scores for league and season pair
  def handle_call({:get_scores, league, season, format}, _from, state) when is_binary(league) and is_binary(season) do
    try do
      result = 
        state
        |> get_in([league, season, :stats])
        |> encode_in(format)

      {:reply, {:ok, result}, state}
    rescue 
      e ->
        IO.puts("An error occurred while pocessing GenServer state: " <> e.message)
        {:reply, {:error, e.message}, state}
    end
  end

  def handle_call({:get_scores, _league, _season, _format}, _from, state) do
    {:reply, {:error, "Unprocessable entity"}, state}
  end
end
