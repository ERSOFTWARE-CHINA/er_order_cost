# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RestfulApi.Repo.insert!(%RestfulApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias RestfulApi.Repo
alias RestfulApi.Accounts.User

admin = 
  %User{
    name: "admin",
    password_hash: Comeonin.Pbkdf2.hashpwsalt("admin123"),
    email: "admin@phx.com",
    real_name: "WangLei",
    position: "Administrator",
    perms_number: 255,
    actived: true,
    is_admin: true
  }

user01 = 
  %User{
    name: "user01",
    password_hash: Comeonin.Pbkdf2.hashpwsalt("user01"),
    email: "user01@phx.com",
    real_name: "LiMing",
    perms_number: 0,
    actived: true,
    is_admin: false
  }

Repo.insert(admin)
Repo.insert(user01)