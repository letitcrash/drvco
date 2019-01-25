# Drvc_0

**Drvc_0 is a web application that serves football match statistics over HTTP API**

  - Elixir Umbrella Application
  - Phoenix Framework 1.4 for API
  - JSON and Protocol Buffers
  - Dockerized
  - HAProxy instance load balancing
  - No database, data stored in GenServer

# Running application

### With docker
  * Build and run `docker-compose up -d`
  * Scale api to N instances `docker-compose scale api=N`
  * Check running containers `docker ps`
  
### Locally
  * Install dependencies with `mix deps.get`
  * Run tests with `mix test` from repo root dir
  * Start Phoenix endpoint with `mix phx.server`

# API

### List available leagues and season pairs
  * JSON `GET /api/leagues`
  * Proto `GET /api/proto/leagues`

### List match statistic for specific leagues and season
  * JSON `GET /api/leagues/SP1/seasons/201617/scores`
  * Proto `GET /api/proto/SP1/201617`
 
# Application structure

### API
Minimal Phoenix 1.4 application with no ecto, no HTML, no Webpack. 

### FootballService
Supervised GenServer (Store module) starts with application and loading initial state from csv file parser (CsvParser module). Protocol Buffers transfomation is handled in Proto module


