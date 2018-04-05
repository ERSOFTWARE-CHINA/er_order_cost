defmodule RestfulApi.Repo.Migrations.CreateMaterialRequisitions do
  use Ecto.Migration

  def change do
    create table(:material_requisitions) do
      add :no, :string
      add :price, :float
      add :date, :date
      add :remark, :text
      add :order_id, references(:orders)
      add :project_id, references(:projects)
      timestamps()
    end

    create table(:material_requisitions_details) do
      add :price, :float
      add :amount, :integer
      add :total_price, :float
      add :sparepart_id, references(:spareparts)
      add :material_requisition_id, references(:material_requisitions)
      timestamps()
    end

  end
end
