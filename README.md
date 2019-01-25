# Drvc_0

**Drvc_0 is a web application that serves football match statistics over HTTP API**

  - Elixir Umbrella Application
  - JSON and Protocol Buffers
  - Dockerized
  - HAProxy instance load balancing

# Running application

### In docker
  * Build and run `docker-compose up -d`
  * Scale api to N instances `docker-compose scale api=3`
  
### Running locally
  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`

# API
  * List available leagues and season pairs
  * List match statistic for specific leagues and season

