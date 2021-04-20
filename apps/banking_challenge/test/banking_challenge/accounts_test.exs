defmodule BankingChallenge.AccountsTest do
  use BankingChallenge.DataCase, async: true

  alias BankingChallenge.Accounts
  alias BankingChallenge.Accounts.Inputs
  alias BankingChallenge.Accounts.Schemas.Account

  # Triple A: Arrange, Act and Assert

  describe "create_new_accout/1" do
    test "fail if email is already taken" do
      # 1. Arrange
      email = "#{Ecto.UUID.generate()}@email.com"
      Repo.insert!(%Account{email: email})

      # 2. Act and 3. Assert
      assert {:error, _changeset} =
               Accounts.create_new_account(%Inputs.Create{owner_name: "Some Name", email: email})
    end

    test "successfully create an account with valid input" do
      # 1. Arrange
      email = "#{Ecto.UUID.generate()}@email.com"

      input = %Inputs.Create{
        owner_name: "Some name",
        email: email,
        email_confirmation: email
      }

      # 2. Act and 3. Assert
      assert {:ok, account} = Accounts.create_new_account(input)
      assert account.owner_name == "Some name"
      assert account.email == email

      query = from(a in Account, where: a.email == ^email)

      assert [^account] = Repo.all(query)
    end
  end

  describe "withdraw_account/1" do
    test "fail if withdraw amount is bigger than balance" do
      # 1. Arrange
      email = "#{Ecto.UUID.generate()}@email.com"

      Accounts.create_new_account(%Inputs.Create{
        owner_name: "Some name",
        email: email,
        email_confirmation: email
      })

      # 2. Act and 3. Assert
      assert {:error, _changeset} =
               Accounts.withdraw_account(%Inputs.Withdraw{
                 email: email,
                 amount: 200_000
               })
    end

    test "successfully withdraw from an account with valid input" do
      # 1. Arrange
      email = "#{Ecto.UUID.generate()}@email.com"

      Accounts.create_new_account(%Inputs.Create{
        owner_name: "Some name",
        email: email,
        email_confirmation: email
      })

      # 2. Act and 3. Assert
      assert {:ok, _changeset} =
               Accounts.withdraw_account(%Inputs.Withdraw{
                 email: email,
                 amount: 50000
               })
    end
  end

  describe "transfer/1" do
    test "fail if transfer amount is bigger than source account balance" do
      # 1. Arrange
      source_email = "#{Ecto.UUID.generate()}@email.com"
      target_email = "#{Ecto.UUID.generate()}@email.com"

      Accounts.create_new_account(%Inputs.Create{
        owner_name: "Source Account",
        email: source_email,
        email_confirmation: source_email
      })

      Accounts.create_new_account(%Inputs.Create{
        owner_name: "Target Account",
        email: target_email,
        email_confirmation: target_email
      })

      # 2. Act and 3. Assert
      assert {:error, _changeset} =
               Accounts.transfer(%Inputs.Transfer{
                 from_email: source_email,
                 to_email: target_email,
                 amount: 200_000
               })
    end

    test "successfully transfer between accounts with valid input" do
      # 1. Arrange
      source_email = "#{Ecto.UUID.generate()}@email.com"
      target_email = "#{Ecto.UUID.generate()}@email.com"

      Accounts.create_new_account(%Inputs.Create{
        owner_name: "Source Account",
        email: source_email,
        email_confirmation: source_email
      })

      Accounts.create_new_account(%Inputs.Create{
        owner_name: "Target Account",
        email: target_email,
        email_confirmation: target_email
      })

      # 2. Act and 3. Assert
      assert :ok =
               Accounts.transfer(%Inputs.Transfer{
                 from_email: source_email,
                 to_email: target_email,
                 amount: 50000
               })
    end
  end
end
