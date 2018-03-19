defmodule RestfulApi.Repo.Migrations.AlterRolesAddRalationWithProject do
  use Ecto.Migration

  def change do
    alter table(:roles) do
      add :project_id, references(:projects)
    end
  end
end
