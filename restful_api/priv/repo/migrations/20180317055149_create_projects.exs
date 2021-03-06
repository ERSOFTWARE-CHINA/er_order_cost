defmodule RestfulApi.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string, null: false
      add :perms_number, :integer, null: false
      add :actived, :Boolean, null: false
      add :deadline, :string
      timestamps()
    end

    create unique_index(:projects, [:name])

  end
end
