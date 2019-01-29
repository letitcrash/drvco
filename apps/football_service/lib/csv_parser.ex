defmodule FootballService.CsvParser do
  @moduledoc """
  Parses CSV files at hardcoded path and reduces csv file structure
  to structured maps 
  """

  @data_file_name "Data.csv"

  @doc """
  Entry point to start transforming process at hardcoded file path.
  Reads file and returns structured map of leagues parsed from CSV file.

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
    Application.app_dir(:football_service, "priv/" <> @data_file_name)
    |> read_file!
    |> parse_csv
  end

  defp read_file!(data_file_path) do 
    data_file_path
    |> File.read!() 
    |> String.split(~r/\R/)
  end

  @spec parse_csv(list()) :: list(map())
  defp parse_csv([header | data]) do
    data
    |> Stream.map(&String.split(&1, ","))
    |> Stream.filter(&valid_row?(&1))
    |> Stream.map(&zip(&1, with_header: header))
    |> Enum.reduce(%{}, fn record, acc ->
      merge(acc, record)
    end)
  end

  defp merge(acc, record) do
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

  defp zip(record, with_header: header) do
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
