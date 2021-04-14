defmodule BankingChallengeWeb.Router do
  use BankingChallengeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankingChallengeWeb do
    pipe_through :api
  end
end