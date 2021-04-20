defmodule BankingChallenge.Repo.Migrations.CreateTransaction do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:type, :string)
      add(:amount, :bigint)
      add(:source_account_email, :string)
      add(:target_account_email, :string)

      timestamps(updated_at: false)
    end
  end
end
