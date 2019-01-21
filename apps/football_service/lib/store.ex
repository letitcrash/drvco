defmodule FootballService.Store do
  use GenServer
  alias FootballService.CSVParser

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :footal_stats_store)
  end

  def init(_) do
    {:ok, CSVParser.init}
  end

  def list_leagues_and_seasons do
    GenServer.call(:footal_stats_store, {:list_leagues_and_seasons})
  end

  def get_match_stats_for(league: league, season: season) do
    GenServer.call(:footal_stats_store, {:get_stats_for, %{league: league, season: season}})
  end

  #Callbacks

  def handle_call({:list_leagues_and_seasons}, _from, state) do
    keys = 
      Map.keys(state)
      |> Enum.map(fn league -> 
        %{league: league, seasons: Map.keys(state[league])}
      end)
    
    {:reply, keys, state}
  end
  
  def handle_call({:get_stats_for, %{league: league, season: season}}, _from, state) do
    result = state[league][season][:data]
    {:reply, result, state}
  end
end
