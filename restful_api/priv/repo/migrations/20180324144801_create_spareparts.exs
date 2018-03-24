defmodule RestfulApi.Repo.Migrations.CreateSpareparts do
  use Ecto.Migration

  def change do
    create table(:spareparts) do
      add :name, :string
      add :attributes, :string
      add :specifications, :string

      timestamps()
    end

  end
end
