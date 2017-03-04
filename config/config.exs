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
  secret_key_base: "/iG9ggfjEQSorN3W0pMbM6AGLBpmJ35BUrvcgBY8PTlAAaiwsFL4T6/jUWe6v+jd",
  render_errors: [view: Whale2.ErrorView, accepts: ~w(json)],
  pubsub: [name: Whale2.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :arc,
    bucket: "whale2",
    virtual_host: true

config :ex_aws,
    access_key_id: Application.get_env(:aws_keys, :access_key_id),
    secret_access_key: Application.get_env(:aws_keys, :secret_access_key),
    region: "us-west-1",
    host: "s3-us-west-1.amazonaws.com",
    s3: [
        scheme: "https://",
        host: "s3-us-west-1.amazonaws.com",
        region: "us-west-1"
    ]