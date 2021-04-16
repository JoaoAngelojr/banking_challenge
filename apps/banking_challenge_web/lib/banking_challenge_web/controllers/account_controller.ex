defmodule BankingChallengeWeb.AccountController do
  @moduledoc """
  Actions related to the account resource.
  """
  use BankingChallengeWeb, :controller

  alias BankingChallenge.Accounts
  alias BankingChallenge.Accounts.Inputs.Create

  alias BankingChallengeWeb.InputValidation

  @doc """
  Create account action.
  """
  def create(conn, params) do
    with {:ok, input} <- InputValidation.cast_and_apply(params, Create),
         {:ok, account} <- Accounts.create_new_account(input) do
      send_json(conn, 200, account)
    else
      {:error, %Ecto.Changeset{}} ->
        msg = %{type: "bad_input", description: "Invalid input"}
        send_json(conn, 400, msg)

      {:error, :email_conflict} ->
        msg = %{type: "conflict", description: "Email already taken"}
        send_json(conn, 412, msg)
    end
  end

  defp send_json(conn, status, body) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(status, Jason.encode!(body))
  end
end
