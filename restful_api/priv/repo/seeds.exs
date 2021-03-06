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
import Ecto.Changeset
alias RestfulApi.Repo
alias RestfulApi.Tenant.Project

proj1 =
  %Project{}
  |> Project.changeset(%{
    name: "root_project",
    perms_number: 137_438_953_471,
    actived: true
  })
  |> Repo.insert!()

proj2 =
  %Project{}
  |> Project.changeset(%{
    name: "user_project",
    perms_number: 255,
    actived: true
  })
  |> Repo.insert!()

#####################################################
# 初始化root用户(超级管理员)，和admin用户(用户管理员)
# 所属项目：root_project  用户名：root   密码：root123
# 所属项目：user_project  用户名：admin  密码：admin123
#####################################################
alias RestfulApi.Accounts.User

root =
  %User{}
  |> User.changeset(%{
    name: "root",
    password: "root123",
    email: "root@phx.com",
    real_name: "如特",
    position: "Root Administrator",
    perms_number: 255,
    actived: true,
    is_admin: true,
    is_root: true
  })
  |> put_assoc(:project, proj1)
  |> Repo.insert()

admin =
  %User{}
  |> User.changeset(%{
    name: "admin",
    password_hash: "admin123",
    email: "admin@phx.com",
    real_name: "阿德明",
    position: "User Administrator",
    perms_number: 255,
    actived: true,
    is_admin: true
  })
  |> put_assoc(:project, proj2)
  |> Repo.insert()

#####################################################
# init production
#
#####################################################
alias RestfulApi.ProductionService.Production

production1 =
  %Production{}
  |> Production.changeset(%{
    name: "prod_name01",
    attributes: "prod_attributes01",
    specifications: "prod_specifications01"
  })
  |> put_assoc(:project, proj1)
  |> Repo.insert!()

#####################################################
# init sparepart
#
#####################################################
alias RestfulApi.SparepartService.Sparepart

sparepart =
  %Sparepart{}
  |> Sparepart.changeset(%{
    name: "part_name01",
    attributes: "part_attributes01",
    specifications: "part_specifications01"
  })
  |> put_assoc(:project, proj2)
  |> Repo.insert!()

#####################################################
# init order
#
#####################################################
alias RestfulApi.OrderService.Order
alias RestfulApi.OrderService.OrderDetail

orderDetail01 =
  %OrderDetail{}
  |> OrderDetail.changeset(%{
    price: 12.25,
    amount: 20
  })
  |> put_assoc(:production, production1)
  |> Repo.insert!()

orderDetail02 =
  %OrderDetail{}
  |> OrderDetail.changeset(%{
    price: 14.25,
    amount: 10
  })
  |> put_assoc(:production, production1)
  |> Repo.insert!()

order =
  %Order{}
  |> Order.changeset(%{
    name: "订单名称",
    pno: "12345",
    price: 122.35,
    remark: "备注"
  })
  |> put_assoc(:project,proj1)
  |> put_assoc(:details, [orderDetail01, orderDetail02])
  |> Repo.insert()
