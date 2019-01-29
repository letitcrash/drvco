# Drvc_0

**Drvc_0 is a web application that serves football match statistics over HTTP API**

  - Elixir Umbrella Application
  - Phoenix Framework 1.4 for API (No Ecto, No WebPack)
  - JSON and Protocol Buffers
  - Dockerized
  - HAProxy instance load balancing
  - No database, no state altering required 

# Running application

### In Docker container
  * Build `docker build . -t drvco`
  * Run `docker run -p4000:4000 drvco`

### With HAProxy in Docker Compose 
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
Minimal Phoenix 1.4 application with no ecto, no HTML, no Webpack. Requests data from **FootaballService.Store** module to serve over HTTP in JSON and Protobuff formats. 

### FootballService
GenServer **Store module** provides client API to access football statistics data. Starts supervised with application and loads initial state from **CsvParser** module. Protocol Buffers transfomations and encodingd are handled in **Proto** module with **Proto.Messages** declaing definitions. **Jason** external dependancy provides API to encode data in JSON fromat.

