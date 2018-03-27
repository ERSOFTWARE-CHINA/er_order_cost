defmodule RestfulApi.Repo.Migrations.AlterSparepartAddReferenceToProject do
  use Ecto.Migration

  def change do
    alter table(:spareparts) do
      add :project_id, references(:projects)
    end
  end
end
