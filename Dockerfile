FROM elixir:1.8.0-slim
EXPOSE 4000
WORKDIR /app
RUN mix local.hex --force && mix local.rebar --force
COPY . /app/
ENV MIX_ENV=dev
ENV PORT=4000
RUN mix deps.get
RUN mix deps.compile
RUN mix compile

CMD ["mix", "phx.server", "--no-halt", "--no-compile", "--no-deps-check"]
