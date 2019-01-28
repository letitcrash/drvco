defmodule FootballService.Store do
  use GenServer
  alias FootballService.CsvParser
  alias FootballService.Proto
  require Logger

  @doc """
  Starts the storage 
  """
  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :store)
  end

  @doc """
  initialize storage state from CsvParser
  """
  def init(_) do
    {:ok, CsvParser.init()}
  end

  @doc """
  List available leagues and seasons
  """
  @spec list_leagues() :: {:ok, list(map())} | {:error, String.t()}
  def list_leagues(opts \\ []) do
    format = Keyword.get(opts, :format)
    GenServer.call(:store, {:list_leagues, format})
  end

  @doc """
  List available scores for specific league and season
  """
  @spec get_scores(String, String) :: {:ok, list(map())} | {:error, String.t()}
  def get_scores(league, season, opts \\ []) do
    format = Keyword.get(opts, :format)
    GenServer.call(:store, {:get_scores, league, season, format})
  end

  def encode_in(list, _format) when is_nil(list),
    do: {:error, "League or Season is not available"}

  def encode_in(list, format) when is_nil(format), do: {:ok, list}
  def encode_in(list, :json) when is_list(list), do: Jason.encode(list)
  def encode_in(list, :proto) when is_list(list), do: Proto.encode(list)
  def encode_in(_list, _format), do: {:error, "Unsupported format"}

  def get_leagues(state) do
    state
    |> Map.keys()
    |> Enum.map(&%{league: &1, seasons: get_seasons(state[&1])})
  end

  def get_seasons(state) do
    state
    |> Map.keys()
    |> Enum.map(&%{season: &1})
  end

  # Callbacks

  def handle_call({:list_leagues, format}, _from, state) do
    result =
      state
      |> get_leagues()
      |> encode_in(format)

    {:reply, result, state}
  end

  def handle_call({:get_scores, league, season, format}, _from, state)
      when is_binary(league) and is_binary(season) do
    result =
      state
      |> get_in([league, season, :stats])
      |> encode_in(format)

    {:reply, result, state}
  end

  def handle_call({:get_scores, _league, _season, _format}, _from, state) do
    {:reply, {:error, "Unprocessable entity"}, state}
  end
end
