import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :social_network, SocialNetwork.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "social_network_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :social_network, SocialNetworkWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "eCoFyg93O3zibkDaMQN8hN2fGtI/nRchmRy4lXMx3i5LOpkwh1fhFaphFJL04k4v",
  server: false

# In test we don't send emails.
config :social_network, SocialNetwork.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
