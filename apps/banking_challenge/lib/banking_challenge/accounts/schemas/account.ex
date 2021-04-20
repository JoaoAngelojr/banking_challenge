defmodule BankingChallenge.Accounts.Schemas.Account do
  @moduledoc """
  The entity of Account.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @required [:owner_name, :email, :balance]
  @optional []

  @derive {Jason.Encoder, except: [:__meta__]}

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "accounts" do
    field(:owner_name, :string)
    field(:email, :string)
    field(:balance, :integer)

    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_number(:balance, greater_than_or_equal_to: 0)
    |> unique_constraint(:email)
  end

  def balance_changeset(model, params) do
    model
    |> cast(params, [:balance])
    |> validate_required([:balance])
    |> validate_number(:balance, greater_than_or_equal_to: 0)
  end
end
