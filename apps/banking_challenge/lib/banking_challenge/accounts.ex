defmodule BankingChallenge.Accounts do
  @moduledoc """
  Domain public functions about the accounts context.
  """

  alias BankingChallenge.Accounts.Inputs.Create
  alias BankingChallenge.Accounts.Inputs.Withdraw
  alias BankingChallenge.Accounts.Schemas.Account
  alias BankingChallenge.Repo
  alias Ecto.Multi

  require Logger

  import Ecto.Query

  @doc """
  Given a VALID changeset it attempts to insert a new account.

  It might fail due to email unique index and we transform that return
  into an error tuple.
  """

  @spec create_new_account(Create.t()) ::
          {:ok, Account.t()} | {:error, Ecto.Changeset.t() | :email_conflict}
  def create_new_account(%Create{} = input) do
    Logger.info("Inserting new account")

    params = %{
      owner_name: input.owner_name,
      email: input.email,
      balance: 1000
    }

    with %{valid?: true} = changeset <- Account.changeset(params),
         {:ok, account} <- Repo.insert(changeset) do
      Logger.info("Account successfully inserted. Owner: #{account.owner_name}")
      {:ok, account}
    else
      %{valid?: false} = changeset ->
        Logger.info("Error while inserting new account. Error: #{inspect(changeset)}")
        {:error, changeset}
    end
  rescue
    Ecto.ConstraintError ->
      Logger.error("Email already taken.")
      {:error, :email_conflict}
  end

  def withdraw_account(%Withdraw{} = input) do
    Logger.info("Withdrawing amount")

    params = %{email: input.email, amount: input.amount}

    case get_account_and_withdraw(params) do
      {:ok, %{update: %Account{} = updated}} ->
        Logger.info("Withdraw successfully made.")
        {:ok, updated}

      {:error, _, %Ecto.Changeset{} = changeset, _} ->
        Logger.info("Error while withdrawing amount.")
        {:error, changeset}
    end
  end

  def get_account_and_withdraw(params) do
    Multi.new()
    |> Multi.run(:account, fn repo, _changes ->
      Account
      |> lock("FOR UPDATE")
      |> repo.get_by(email: params.email)
      |> case do
        nil ->
          {:error, :account_not_found}

        account ->
          {:ok, account}
      end
    end)
    |> Multi.run(:update, fn repo, %{account: account} ->
      Account.balance_changeset(account, %{balance: account.balance - params.amount})
      |> repo.update()
    end)
    |> Repo.transaction()
  end
end
