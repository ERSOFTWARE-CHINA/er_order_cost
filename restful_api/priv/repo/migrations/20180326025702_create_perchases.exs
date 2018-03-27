defmodule RestfulApi.Repo.Migrations.CreatePerchases do
  use Ecto.Migration

  def change do
    create table(:purchases) do
      add :pno, :integer
      add :price, :float
      add :date, :date
      add :remark, :text
      add :order_id, references(:orders)
      add :project_id, references(:projects)
      timestamps()
    end

    create table(:purchase_details) do
      add :price, :float
      add :amount, :integer
      add :total_price, :float
      add :purchase_id, references(:purchases)
      timestamps()
    end

  end
end
