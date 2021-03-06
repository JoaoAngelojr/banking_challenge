defmodule BankingChallenge.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:owner_name, :string)
      add(:email, :string)
      add(:balance, :bigint)

      timestamps()
    end

    create(unique_index(:accounts, [:email]))
  end
end
