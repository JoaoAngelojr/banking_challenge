defmodule BankingChallenge.AccountsTest do
  use BankingChallenge.DataCase, async: true

  alias BankingChallenge.Accounts
  alias BankingChallenge.Accounts.Inputs
  alias BankingChallenge.Accounts.Schemas.Account

  # Triple A: Arrange, Act and Assert

  describe "create_new_accout/1" do
    test "fail if email is already taken" do
      # 1. Arrange
      email = "some@email.com"
      Repo.insert!(%Account{email: email})

      # 2. Act and 3. Assert
      assert {:error, :email_conflict} ==
               Accounts.create_new_account(%Inputs.Create{owner_name: "Some Name", email: email})
    end

    test "fail if name has less than three characters" do
      # 1. Arrange
      input = %Inputs.Create{
        owner_name: "So",
        email: "some@email.com",
        email_confirmation: "some@email.com"
      }

      # 2. Act and 3. Assert
      assert {:error, _changeset} = Accounts.create_new_account(input)
    end

    test "successfully create an account with valid input" do
      # 1. Arrange
      input = %Inputs.Create{
        owner_name: "Some name",
        email: "some@email.com",
        email_confirmation: "some@email.com"
      }

      # 2. Act and 3. Assert
      assert {:ok, _account} = Accounts.create_new_account(input)
    end
  end

  describe "withdraw_account/1" do
    test "fail if withdraw amount is bigger than balance" do
      # 1. Arrange
      Accounts.create_new_account(%Inputs.Create{
        owner_name: "Some name",
        email: "some@email.com",
        email_confirmation: "some@email.com"
      })

      # 2. Act and 3. Assert
      assert {:error, _changeset} =
               Accounts.withdraw_account(%Inputs.Withdraw{
                 email: "some@email.com",
                 amount: 2000
               })
    end

    test "successfully withdraw from an account with valid input" do
      # 1. Arrange
      Accounts.create_new_account(%Inputs.Create{
        owner_name: "Some name",
        email: "some@email.com",
        email_confirmation: "some@email.com"
      })

      # 2. Act and 3. Assert
      assert {:ok, _changeset} =
               Accounts.withdraw_account(%Inputs.Withdraw{
                 email: "some@email.com",
                 amount: 500
               })
    end
  end

  describe "transfer/1" do
    test "fail if transfer amount is bigger than source account balance" do
      # 1. Arrange
      Accounts.create_new_account(%Inputs.Create{
        owner_name: "Some name",
        email: "source@email.com",
        email_confirmation: "some@email.com"
      })

      Accounts.create_new_account(%Inputs.Create{
        owner_name: "Some name",
        email: "target@email.com",
        email_confirmation: "some@email.com"
      })

      # 2. Act and 3. Assert
      assert {:error, _changeset} =
               Accounts.transfer(%Inputs.Transfer{
                 from_email: "source@email.com",
                 to_email: "target@email.com",
                 amount: 2000
               })
    end

    test "successfully transfer between accounts with valid input" do
      # 1. Arrange
      Accounts.create_new_account(%Inputs.Create{
        owner_name: "Some name",
        email: "source@email.com",
        email_confirmation: "some@email.com"
      })

      Accounts.create_new_account(%Inputs.Create{
        owner_name: "Some name",
        email: "target@email.com",
        email_confirmation: "some@email.com"
      })

      # 2. Act and 3. Assert
      assert :ok =
               Accounts.transfer(%Inputs.Transfer{
                 from_email: "source@email.com",
                 to_email: "target@email.com",
                 amount: 500
               })
    end
  end
end
