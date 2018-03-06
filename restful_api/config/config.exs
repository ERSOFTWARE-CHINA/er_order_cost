# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :restful_api,
  ecto_repos: [RestfulApi.Repo]

# Configures the endpoint
config :restful_api, RestfulApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2lqW/rHm1/WqWqqoPkH+jNlmZpp0zgWi2C1Uze6JyrLzYbAoat7NE6deoPTaMiCO",
  render_errors: [view: RestfulApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RestfulApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :restful_api, RestfulApiWeb.Guardian,
  issuer: "restful_api",
  secret_key: "Nbf/SLGlHPHLrwsuHHdkC3GyTKPacikz6WFRl5yQh4mZPWVEMOFg11oX+ySnTfKO"

config :arc,
  storage: Arc.Storage.Local # or Arc.Storage.S3

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
