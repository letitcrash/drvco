defmodule FootballServiceTest do
  use ExUnit.Case
  # doctest FootballService

  test "validate data parsing" do
    sp1_201617_last_item = %{
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

    data = FootballService.CSVParser.init()
    [sp1_201617_head_item | _rest] = data["SP1"]["201617"][:stats]
    assert sp1_201617_last_item == sp1_201617_head_item
  end

  test "list available leagues and seasons" do
    available_leagues_and_season = 
      [
        %{league: "D1", seasons: ["201617"]},
        %{league: "E0", seasons: ["201617"]},
        %{league: "SP1", seasons: ["201516", "201617"]},
        %{league: "SP2", seasons: ["201516", "201617"]}
      ]

    {:ok, result} = FootballService.Store.list_leagues_and_seasons
    
    assert available_leagues_and_season == result
  end

  test "fetch the result for specific league and season" do
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

    {:ok, [ first | tail ]}= FootballService.Store.get_match_stats_for(league: "SP1", season: "201617")
    [ last | tail ] = Enum.reverse(tail)

    assert first == first_match
    assert last == last_match
  end
end
