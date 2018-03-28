defmodule RestfulApi.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :name, :string
      add :pno, :string
      add :price, :float
      add :date, :date
      add :remark, :text
      add :project_id, references(:projects)
      timestamps()
    end

    create table(:order_details) do
      add :price, :float
      add :amount, :integer
      add :total_price, :float
      add :order_id, references(:orders)
      add :production_id, references(:productions)
      timestamps()
    end
  end
end
