use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :whale2, Whale2.Endpoint,
  secret_key_base: "JXVU43iu+zTBF6DAQy2y/Uv00bwN+jRbKM9KODtV48uvBtaWaqUKlb4PLWhP4jC5"

# Configure your database
config :whale2, Whale2.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "whale2_prod",
  pool_size: 20

config :whale2,
    access_key_id: "AKIAJFD3C7AA2CDY33UA",
    secret_access_key: "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"

