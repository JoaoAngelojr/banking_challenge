# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :banking_challenge,
  ecto_repos: [BankingChallenge.Repo]

config :banking_challenge_web,
  ecto_repos: [BankingChallenge.Repo],
  generators: [context_app: :banking_challenge, binary_id: true]

# Configures the endpoint
config :banking_challenge_web, BankingChallengeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5jIHNQ9w1+rl571xO0QYepDyJcXiYt/tUnMDKVATHamCv1zSCYFkUK2WGXZCbDg0",
  render_errors: [view: BankingChallengeWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: BankingChallenge.PubSub,
  live_view: [signing_salt: "B6aXSEhx"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
