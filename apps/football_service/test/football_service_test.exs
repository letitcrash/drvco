defmodule FootballServiceTest do
  use ExUnit.Case
  # doctest FootballService

  test "validate data parsing" do
    sp1_201617_last_item = [
      Date: "21/05/2017",
      HomeTeam: "Valencia",
      AwayTeam: "Villarreal",
      FTHG: "1",
      FTAG: "3",
      FTR: "A",
      HTHG: "0",
      HTAG: "1",
      HTR: "A"
    ]

    data = FootballService.CSVParser.init()
    [sp1_201617_head_item | _rest] = data["SP1"]["201617"][:data]
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

    assert available_leagues_and_season == 
      FootballService.Store.list_leagues_and_seasons
  end

  test "fetch the result for specific league and season" do
    sp1_201617_first_match = [
      Date: "21/05/2017",
      HomeTeam: "Valencia",
      AwayTeam: "Villarreal",
      FTHG: "1",
      FTAG: "3",
      FTR: "A",
      HTHG: "0",
      HTAG: "1",
      HTR: "A"
    ]

    [first | _rest] = 
      FootballService.Store.get_match_stats_for(league: "SP1", season: "201617")
    
    assert first == sp1_201617_first_match
  end
end
