defmodule BankingChallenge.Accounts.Schemas.Account do
  @moduledoc """
  The entity of Account.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @email_regex ~r/^[A-Za-z0-9\._%+\-+']+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,4}$/

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
    |> validate_length(:owner_name, min: 3)
    |> validate_number(:balance, greater_than_or_equal_to: 0)
    |> validate_format(:email, @email_regex)
  end
end
