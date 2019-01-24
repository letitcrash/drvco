defmodule FootballServiceTest do
  use ExUnit.Case
  alias FootballService.Store
  alias FootballService.CSVParser
  doctest FootballService

  test "validate data parsing" do
    test_item = %{
      Date: "21/05/2017",
      HomeTeam: "Valencia",
      AwayTeam: "Villarreal",
      FTHG: "1",
      FTAG: "3",
      FTR: "A",
      HTHG: "0",
      HTAG: "1",
      HTR: "A"
    }

    data = CSVParser.init()
    [parsed_item | _rest] = data["SP1"]["201617"][:stats]

    assert test_item == parsed_item
  end

  test "list available leagues and seasons from store" do
    available_leagues_and_season = 
      [
        %{league: "D1", seasons: ["201617"]},
        %{league: "E0", seasons: ["201617"]},
        %{league: "SP1", seasons: ["201516", "201617"]},
        %{league: "SP2", seasons: ["201516", "201617"]}
      ]

    {:ok, result} = Store.list_leagues()
    
    assert available_leagues_and_season == result
  end

  test "fetch the result for specific league and season in store" do
    first_match = %{
      Date: "21/05/2017",
      HomeTeam: "Valencia",
      AwayTeam: "Villarreal",
      FTHG: "1",
      FTAG: "3",
      FTR: "A",
      HTHG: "0",
      HTAG: "1",
      HTR: "A"
    }

    last_match = %{
      Date: "19/08/2016",
      HomeTeam: "La Coruna",
      AwayTeam: "Eibar",
      FTHG: "2",
      FTAG: "1",
      FTR: "H",
      HTHG: "0",
      HTAG: "0",
      HTR: "D"
    }

    {:ok, [ first | tail ]} = 
     Store.get_scores_for(league: "SP1", season: "201617")

    [ last | _tail ] = Enum.reverse(tail)

    assert first == first_match
    assert last == last_match
  end

  test "invalid data test from storage" do
    assert {:error, "League or Season is not available"} == Store.get_scores_for(league: "SP1", season: "NA")
    assert {:error, "League or Season is not available"} == Store.get_scores_for(league: "NA", season: "201617")
    assert {:error, "League or Season is not available"} == Store.get_scores_for(league: "NA", season: "NA")
  end
end
