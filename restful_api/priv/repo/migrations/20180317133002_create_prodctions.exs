defmodule RestfulApi.Repo.Migrations.CreateProductions do
  use Ecto.Migration

  def change do
    create table(:productions) do
      add :name, :string
      add :attributes, :string
      add :specifications, :string

      timestamps()
    end

  end
end
