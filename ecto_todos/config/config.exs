# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ecto_todos,
  ecto_repos: [EctoTodos.Repo]

# Configures the endpoint
config :ecto_todos, EctoTodosWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "IZo9pZawFipPMqGsoxFkDQPq+xOAFQi69GIOEqNGeAjknx40dU3q14RKlP06odsi",
  render_errors: [view: EctoTodosWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: EctoTodos.PubSub,
  live_view: [signing_salt: "5Juht5Pd"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
