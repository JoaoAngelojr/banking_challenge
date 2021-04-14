defmodule BankingChallengeWeb.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      BankingChallengeWeb.Telemetry,
      BankingChallengeWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: BankingChallengeWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    BankingChallengeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
