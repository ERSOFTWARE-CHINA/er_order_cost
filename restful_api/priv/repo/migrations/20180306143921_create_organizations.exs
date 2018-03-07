defmodule RestfulApi.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string, null: false
      add :parent_id, references(:organizations, on_delete: :nothing)

      timestamps()
    end

    alter table(:users) do
      add :organization_id, references(:organizations)
    end

  end
end
