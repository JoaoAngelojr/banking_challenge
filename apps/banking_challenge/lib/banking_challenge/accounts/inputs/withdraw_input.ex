defmodule BankingChallenge.Accounts.Inputs.Withdraw do
  @moduledoc """
  Input data for calling withdraw_account/1.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @required [:email, :amount]
  @optional []

  @primary_key false
  embedded_schema do
    field(:email, :string)
    field(:amount, :integer)
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_number(:amount, greater_than: 0)
  end
end
