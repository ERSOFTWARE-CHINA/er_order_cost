defmodule RestfulApi.Repo.Migrations.CreateProdctions do
  use Ecto.Migration

  def change do
    create table(:prodctions) do
      add :name, :string
      add :attributes, :string
      add :specifications, :string

      timestamps()
    end

  end
end