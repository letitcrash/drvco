defmodule FootballServiceTest do
  use ExUnit.Case
  alias FootballService.Store
  alias FootballService.CSVParser
  doctest FootballService

  @league "SP1"
  @season "201617"
  @unavailable_league "XX1"
  @unavailable_season "201819"
  @invalid_league 123
  @invalid_season :season

  @first_match %{
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

  @last_match %{
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

  @leagues_list [
    %{league: "D1", seasons: [%{season: "201617"}]},
    %{league: "E0", seasons: [%{season: "201617"}]},
    %{league: "SP1", seasons: [%{season: "201516"}, %{season: "201617"}]},
    %{league: "SP2", seasons: [%{season: "201516"}, %{season: "201617"}]}
  ]

  test "validate data parsing" do
    data = CSVParser.init()
    [first_item | _rest] = data["SP1"]["201617"][:stats]

    assert first_item == @first_match
  end

  test "list available leagues and seasons from store" do
    assert Store.list_leagues() == {:ok, @leagues_list}
  end

  test "fetch the result for specific league and season from store" do
    {:ok, [first | tail]} = Store.get_scores(@league, @season)
    [last | _tail] = Enum.reverse(tail)

    assert first == @first_match
    assert last == @last_match
  end

  test "invalid data from storage tests" do
    assert {:error, "League or Season is not available"} ==
             Store.get_scores(@league, @unavailable_season)

    assert {:error, "League or Season is not available"} ==
             Store.get_scores(@unavailable_league, @season)

    assert {:error, "League or Season is not available"} ==
             Store.get_scores(@unavailable_league, @unavailable_season)

    assert {:error, "Unprocessable entity"} == Store.get_scores(@invalid_league, @season)
    assert {:error, "Unprocessable entity"} == Store.get_scores(@league, @invalid_season)
    assert {:error, "Unsupported format"} == Store.get_scores(@league, @season, format: :xml)
  end
end
