defmodule BankingChallengeWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :banking_challenge_web

  @session_options [
    store: :cookie,
    key: "_banking_challenge_web_key",
    signing_salt: "pux4GkiI"
  ]

  if code_reloading? do
    plug(Phoenix.CodeReloader)
    plug(Phoenix.Ecto.CheckRepoStatus, otp_app: :banking_challenge_web)
  end

  plug(Plug.RequestId)
  plug(Plug.Telemetry, event_prefix: [:phoenix, :endpoint])

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)
  plug(Plug.Session, @session_options)
  plug(BankingChallengeWeb.Router)
end
