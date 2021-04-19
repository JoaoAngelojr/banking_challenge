defmodule BankingChallenge.Accounts do
  @moduledoc """
  Domain public functions about the accounts context.
  """

  alias BankingChallenge.Accounts.Inputs.Create
  alias BankingChallenge.Accounts.Inputs.Withdraw
  alias BankingChallenge.Accounts.Inputs.Transfer
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

  @doc """
  Given a VALID changeset it attempts to withdraw an amount from an account.

  It might fail if the given account has an insufficient balance.
  """
  @spec withdraw_account(Withdraw.t()) ::
          {:ok, Account.t()} | {:error, Ecto.Changeset.t()}
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

  @doc """
  Given a VALID changeset it attempts to transfer an amount between accounts.

  It might fail if the source account has an insufficient balance.
  """
  @spec transfer(Transfer.t()) ::
          :ok | {:error, Ecto.Changeset.t()}
  def transfer(%Transfer{} = input) do
    Logger.info("Transferring amount")

    params = %{from_email: input.from_email, to_email: input.to_email, amount: input.amount}

    case get_accounts_and_transfer(params) do
      {:ok, _} ->
        Logger.info("Transfer successfully made.")
        :ok

      {:error, _, %Ecto.Changeset{} = changeset, _} ->
        Logger.info("Error while transferring amount.")
        {:error, changeset}
    end
  end

  defp get_account_and_withdraw(params) do
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

  defp get_accounts_and_transfer(params) do
    Multi.new()
    |> Multi.run(:from_account, fn repo, _changes ->
      Account
      |> lock("FOR UPDATE")
      |> repo.get_by(email: params.from_email)
      |> case do
        nil ->
          {:error, :from_account_not_found}

        from_account ->
          {:ok, from_account}
      end
    end)
    |> Multi.run(:update_from_account, fn repo, %{from_account: from_account} ->
      Account.balance_changeset(from_account, %{balance: from_account.balance - params.amount})
      |> repo.update()
    end)
    |> Multi.run(:to_account, fn repo, _changes ->
      Account
      |> repo.get_by(email: params.to_email)
      |> case do
        nil ->
          {:error, :to_account_not_found}

        to_account ->
          {:ok, to_account}
      end
    end)
    |> Multi.run(:update_to_account, fn repo, %{to_account: to_account} ->
      Account.balance_changeset(to_account, %{balance: to_account.balance + params.amount})
      |> repo.update()
    end)
    |> Repo.transaction()
    |> IO.inspect()
  end
end
