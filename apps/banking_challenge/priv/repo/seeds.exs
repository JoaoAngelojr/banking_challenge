# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BankingChallenge.Repo.insert!(%BankingChallenge.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

BankingChallenge.Repo.insert!(
  %BankingChallenge.Accounts.Schemas.Account{
    owner_name: "Some User Name",
    email: "some.email@email.com.br",
    balance: 1000
  },
  on_conflict: :nothing
)
