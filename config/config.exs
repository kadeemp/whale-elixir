# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :whale2,
  ecto_repos: [Whale2.Repo]

# Configures the endpoint
config :whale2, Whale2.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: Whale2.ErrorView, accepts: ~w(json)],
  pubsub: [name: Whale2.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :arc,
    bucket: "whale-bucket",
    virtual_host: true,
    version_timeout: 195_000

config :ex_aws,
    access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
    secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
    host: "s3-us-west-2.amazonaws.com",
    region: "us-west-2",
    s3: [
        scheme: "https://",
        host: "s3-us-west-2.amazonaws.com",
        region: "us-west-2"
    ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"