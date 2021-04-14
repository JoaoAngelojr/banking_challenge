import Config

config :banking_challenge,
  ecto_repos: [BankingChallenge.Repo]

config :banking_challenge_web,
  ecto_repos: [BankingChallenge.Repo],
  generators: [context_app: :banking_challenge, binary_id: true]

config :banking_challenge_web, BankingChallengeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5jIHNQ9w1+rl571xO0QYepDyJcXiYt/tUnMDKVATHamCv1zSCYFkUK2WGXZCbDg0",
  render_errors: [view: BankingChallengeWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: BankingChallenge.PubSub,
  live_view: [signing_salt: "B6aXSEhx"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
