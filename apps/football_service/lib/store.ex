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

  def encode_in(list, _format) when is_nil(list), do: {:error, "League or Season is not available"}
  def encode_in(list, format) when is_nil(format), do: {:ok, list}
  def encode_in(list, :json) when is_list(list), do: Jason.encode(list)
  def encode_in(list, :proto) when is_list(list), do: Proto.encode(list)
  def encode_in(_list, _format), do: {:error, "Unsupported format"}

  def get_leagues(state) do
    case Map.keys(state) do
      nil -> 
        nil
      keys -> 
        Enum.map(keys, fn k -> %{league: k, seasons: get_seasons(state[k])} end)
    end
  end

  def get_seasons(st) do
    case Map.keys(st) do
      nil -> 
        nil
      seasons ->
        Enum.map(seasons, fn sk -> %{season: sk} end)
    end
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
