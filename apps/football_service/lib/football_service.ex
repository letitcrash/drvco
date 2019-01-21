defmodule FootballService do
  use Application

  def start(_type, _args) do 
    FootballService.Supervisor.start_link
  end
end
