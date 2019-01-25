# Drvc_0

**Drvc_0 is a web application that serves football match statistics over HTTP API**

  - Elixir Umbrella Application
  - Phoenix Framework 1.4 for API
  - JSON and Protocol Buffers
  - Dockerized
  - HAProxy instance load balancing
  - No database, data stored in GenServer

# Running application

### In docker
  * Build and run `docker-compose up -d`
  * Scale api to N instances `docker-compose scale api=3`
  * Check running containers `docker ps`
  
### Running locally
  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`

# API
  * List available leagues and season pairs
  `/api/leagues`
  * List match statistic for specific leagues and season
  `/api/leagues/SP1/seasons/201617/scores`

