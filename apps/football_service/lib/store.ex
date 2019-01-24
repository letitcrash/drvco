defmodule FootballService.Store do
  use GenServer
  alias FootballService.CSVParser

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :footal_stats_store)
  end

  def init(_) do
    {:ok, CSVParser.init}
  end

  def list_leagues do
    GenServer.call(:footal_stats_store, {:list_leagues_and_seasons})
  end

  def get_scores_for(league: league, season: season) do
    GenServer.call(:footal_stats_store, {:get_scores_for, %{league: league, season: season}})
  end

  defp get_leagues_and_seasons_for(state) do
    Map.keys(state)
    |> Enum.map(fn league ->
      %{league: league, seasons: Map.keys(state[league])}
    end)
  end

  #Callbacks

  def handle_call({:list_leagues_and_seasons}, _from, state) do
    case get_leagues_and_seasons_for(state) do
      nil ->
        {:reply, {:error, "No leagues and seasons found"}, state}
      leagues ->
        {:reply, {:ok, leagues}, state}
    end
  end
  
  def handle_call({:get_scores_for, %{league: league, season: season}}, _from, state) do
    case result = get_in(state, [league, season, :stats]) do
      nil ->
        {:reply, {:error, "League or Season is not available"}, state}
      _ ->
        {:reply, {:ok, result}, state}
    end
  end
end
