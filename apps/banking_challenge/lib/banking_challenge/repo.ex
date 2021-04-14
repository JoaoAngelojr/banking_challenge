defmodule BankingChallenge.Repo do
  use Ecto.Repo,
    otp_app: :banking_challenge,
    adapter: Ecto.Adapters.Postgres
end
