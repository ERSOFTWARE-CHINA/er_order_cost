defmodule RestfulApi.Repo.Migrations.AlterPurchaseDetailsAddReferenceToSparepart do
  use Ecto.Migration

  def change do
    alter table(:purchase_details) do
      add :sparepart_id, references(:spareparts)
    end
  end
end
