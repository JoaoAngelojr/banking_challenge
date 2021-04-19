defmodule BankingChallenge.Accounts.Inputs.Withdraw do
  @moduledoc """
  Input data for calling withdraw_account/1.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @email_regex ~r/^[A-Za-z0-9\._%+\-+']+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,4}$/

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
    |> validate_format(:email, @email_regex)
    |> validate_number(:amount, greater_than: 0)
  end
end
