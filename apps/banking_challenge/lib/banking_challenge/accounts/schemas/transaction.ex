defmodule BankingChallenge.Accounts.Schemas.Transaction do
  @moduledoc """
  The entity of Transaction.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @required [:type, :amount, :source_account_email]
  @optional [:target_account_email]

  @derive {Jason.Encoder, except: [:__meta__]}

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "transactions" do
    field(:type, :string)
    field(:amount, :integer)
    field(:source_account_email, :string)
    field(:target_account_email, :string)

    timestamps(updated_at: false)
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
