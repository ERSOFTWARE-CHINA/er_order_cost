defmodule RestfulApi.Repo.Migrations.AlterProductionsAndSparepartsAddProjectId do
  use Ecto.Migration

  def change do
    alter table(:productions) do
      add :project_id, references(:projects)
    end
    alter table(:spareparts) do
      add :project_id, references(:projects)
    end
  end
end
