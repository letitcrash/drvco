defmodule FootballService.Store do
  use GenServer
  alias FootballService.CsvParser
  alias FootballService.Proto
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :store)
  end

  def init(_) do
    {:ok, CsvParser.init()}
  end

  def list_leagues(opts \\ []) do
    format = Keyword.get(opts, :format)
    GenServer.call(:store, {:list_leagues, format})
  end

  def get_scores(league, season, opts \\ []) do
    format = Keyword.get(opts, :format)
    GenServer.call(:store, {:get_scores, league, season, format})
  end

  def encode_in(list, _format) when is_nil(list), do: raise("League or Season is not available")
  def encode_in(list, format) when is_nil(format), do: list
  def encode_in(list, :json) when is_list(list), do: Jason.encode!(list)
  def encode_in(list, :proto) when is_list(list), do: Proto.encode(list)
  def encode_in(_list, _format), do: raise("Unsupported format")

  def get_season_keys(list) do
    list
    |> Map.keys()
    |> Enum.map(fn i -> %{season: i} end)
  end

  # Callbacks

  def handle_call({:list_leagues, format}, _from, state) do
    try do
      result =
        state
        |> Map.keys()
        |> Enum.map(&%{league: &1, seasons: get_season_keys(state[&1])})
        |> encode_in(format)

      {:reply, {:ok, result}, state}
    rescue
      e ->
        IO.puts("An error occurred while pocessing GenServer state: " <> e.message)
        {:reply, {:error, e.message}, state}
    end
  end

  def handle_call({:get_scores, league, season, format}, _from, state)
      when is_binary(league) and is_binary(season) do
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
