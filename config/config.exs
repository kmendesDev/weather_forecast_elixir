import Config

config :weather, Weathers.Repo,
  database: "weather_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :weather, ecto_repos: [Weathers.Repo]