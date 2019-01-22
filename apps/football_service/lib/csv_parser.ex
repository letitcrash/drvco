defmodule FootballService.CSVParser do
  @moduledoc """
  Documentation for FootballService.
  """

  @football_stats_file_path "Data.csv"

  @doc """
  Initialization of a storage.

  ## Examples

  iex> FootballService.init()
  %{
    "SP1" => %{
      "201617" => %{
        data: [                                                                                                                                             
          Date: "04/06/2017",                                                                                                                         
          HomeTeam: "Girona",                                                                                                                         
          AwayTeam: "Zaragoza",                                                                                                                       
          FTHG: "0",                                                                                                                                  
          FTAG: "0",                                                                                                                                  
          FTR: "D",                                                                                                                                   
          HTHG: "0",                                                                                                                                  
          HTAG: "0",                                                                                                                                  
          HTR: "D"                                                                                                                                    
        ]
      },
      ...
    },
    ...
  }

  """
  def init do
    @football_stats_file_path
    |> read_file!
    |> parse_csv
  end

  def read_file!(path), do: File.read!(path) |> String.split(~r/\R/)

  def parse_csv([header | data]) do
    data
    |> Stream.map(&String.split(&1, ","))
    |> Stream.filter(&valid_row?(&1))
    |> Stream.map(&zip(&1, with_header: header))
    |> Enum.reduce(%{}, fn record, acc ->
      merge(acc, record)
    end)
  end

  def merge(acc, record) do
    case record do
      [{:Div, league} | tail] ->
        inner_map = merge(Map.get(acc, league, %{}), tail)
        Map.put(acc, league, inner_map)

      [{:Season, season} | tail] ->
        inner_map = merge(Map.get(acc, season, %{}), tail)
        Map.put(acc, season, inner_map)

      _ ->
        if is_nil(acc[:stats]) do
          Map.put(acc, :stats, [Map.new(record)])
        else 
          Map.put(acc, :stats, [Map.new(record) | acc[:stats]])
        end
    end
  end

  def zip(record, with_header: header) do
    header
    |> String.split(",")
    |> Enum.map(fn el -> String.to_atom(el) end)
    |> Enum.zip(record)
    |> Enum.drop(1)
  end

  defp valid_row?(row) do
    case row do
      [_id, _div, _season, _date, _ht, _at, _fthg, _ftag, _ftr, _hthg, _htag, _htr] ->
        true

      _ ->
        false
    end
  end
end
