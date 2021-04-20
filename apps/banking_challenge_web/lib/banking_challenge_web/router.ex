defmodule BankingChallengeWeb.Router do
  use BankingChallengeWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", BankingChallengeWeb do
    pipe_through(:api)

    post("/accounts", AccountController, :create)
    post("/accounts/withdraw", AccountController, :withdraw)
    post("/accounts/transfer", AccountController, :transfer)
    get("/accounts/:id", AccountController, :get_account)
  end
end
