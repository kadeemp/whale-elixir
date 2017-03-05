use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :whale2, Whale2.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []


# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :whale2, Whale2.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "whale2_dev",
  hostname: "localhost",
  pool_size: 10

# Configure Guardian for authentication
config :guardian, Guardian,
  allowed_algos: ["HS512"],
  issuer: "Whale2",
  ttl: {30, :days},
  allowed_drift: 2000,
  secret_key: %{"k" => "0ElO4lQOMLx3zGPx0EHe2ylWl8UBbxzfPIhOk1CW_eiI6lmkQXRNpSj13KLaKTq_uBSFpja7EVAH0dGqol4E6w", "kty" => "oct"},
  serializer: Whale2.GuardianSerializer

import_config "dev.secret.exs"