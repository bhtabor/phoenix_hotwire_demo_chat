import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :phoenix_hotwire_demo_chat, PhoenixHotwireDemoChat.Repo,
  database: Path.expand("../phoenix_hotwire_demo_chat_test.db", __DIR__),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_hotwire_demo_chat, PhoenixHotwireDemoChatWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Qk3yINqLik+GDa0tO/CS67iiQcLh9Arf3Slc2OgOP+Ox1Avh6ROWrU08Ep82d1LZ",
  server: false

# In test we don't send emails
config :phoenix_hotwire_demo_chat, PhoenixHotwireDemoChat.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
