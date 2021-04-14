defmodule BankingChallenge.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      BankingChallenge.Repo,
      {Phoenix.PubSub, name: BankingChallenge.PubSub}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: BankingChallenge.Supervisor)
  end
end
