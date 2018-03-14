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

#################
# 初始化角色
#################
# alias RestfulApi.Repo
# alias RestfulApi.Authentication.Role

# admin_role = 
#   %Role{
#     name: "admin_role",
#     perms_number: 255
#   }

# user_role = 
#   %Role{
#     name: "user_role",
#     perms_number: 1
#   }

# Repo.insert(admin_role)
# Repo.insert(user_role)

#################
# 初始化用户
#################
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