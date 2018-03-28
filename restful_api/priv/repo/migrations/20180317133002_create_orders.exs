defmodule RestfulApi.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :pno, :integer
      add :price, :float
      add :date, :date
      add :remark, :text
      add :project_id, references(:projects)
      timestamps()
    end

    create table(:orders_details) do
      add :price, :float
      add :amount, :integer
      add :total_price, :float
      add :order_id, references(:orders)
      timestamps()
    end
  end
end
