import Config

config :banking_challenge, BankingChallenge.Repo,
  username: "postgres",
  password: "postgres",
  database: "banking_challenge_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :banking_challenge_web, BankingChallengeWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
