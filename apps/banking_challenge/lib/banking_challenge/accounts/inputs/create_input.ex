defmodule BankingChallenge.Accounts.Inputs.Create do
  @moduledoc """
  Input data for calling insert_new_account/1.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @email_regex ~r/^[A-Za-z0-9\._%+\-+']+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,4}$/

  @required [:owner_name, :email, :email_confirmation]
  @optional []

  @primary_key false
  embedded_schema do
    field(:owner_name, :string)
    field(:email, :string)
    field(:email_confirmation, :string)
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_length(:owner_name, min: 3)
    |> validate_format(:email, @email_regex)
    |> validate_format(:email_confirmation, @email_regex)
    |> validate_email_and_confirmation_are_the_same()
  end

  defp validate_email_and_confirmation_are_the_same(changeset) do
    email = get_change(changeset, :email)
    confirmation = get_change(changeset, :email_confirmation)

    if email == confirmation do
      changeset
    else
      add_error(changeset, :email_confirmation, "Email and confirmation must be the same.")
    end
  end
end
