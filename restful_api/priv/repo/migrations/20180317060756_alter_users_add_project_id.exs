defmodule RestfulApi.Repo.Migrations.AlterUsersAddProjectId do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :project_id, references(:projects)
      add :is_root, :boolean, null: false
    end
  end
end
