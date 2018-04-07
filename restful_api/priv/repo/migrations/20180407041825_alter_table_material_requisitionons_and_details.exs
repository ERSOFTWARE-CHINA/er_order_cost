defmodule RestfulApi.Repo.Migrations.AlterTableMaterialRequisitionsAndDetails do
  use Ecto.Migration

  def change do
    alter table(:material_requisitions) do
      add :picker, :string
      remove :price
    end

    alter table(:material_requisitions_details) do
      remove :price
      remove :total_price
    end

  end
end
