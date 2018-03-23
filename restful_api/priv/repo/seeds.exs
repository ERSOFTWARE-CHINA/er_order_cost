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
# 初始化项目
#################
alias RestfulApi.Repo
alias RestfulApi.Tenant.Project

proj1 = 
  %Project{
    name: "root_project",
    perms_number: 137438953471,
    actived: true
  }

proj2 = 
  %Project{
    name: "user_project",
    perms_number: 255,
    actived: true
  }

#####################################################
# 初始化root用户(超级管理员)，和admin用户(用户管理员)
# 所属项目：root_project  用户名：root   密码：root123
# 所属项目：user_project  用户名：admin  密码：admin123
#####################################################
alias RestfulApi.Repo
alias RestfulApi.Accounts.User

root = 
%User{
  name: "root",
  password_hash: Comeonin.Pbkdf2.hashpwsalt("root123"),
  email: "root@phx.com",
  real_name: "如特",
  position: "Root Administrator",
  perms_number: 255,
  actived: true,
  is_admin: true,
  is_root: true,
  project: proj1
}

admin = 
  %User{
    name: "admin",
    password_hash: Comeonin.Pbkdf2.hashpwsalt("admin123"),
    email: "admin@phx.com",
    real_name: "阿德明",
    position: "User Administrator",
    perms_number: 255,
    actived: true,
    is_admin: true,
    project: proj2
  }

Repo.insert(root)
Repo.insert(admin)