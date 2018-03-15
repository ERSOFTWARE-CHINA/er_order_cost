defmodule RestfulApi.Repo.Migrations.CreateConts do
  use Ecto.Migration

  def change do
    create table(:conts) do
      add :name, :string
      add :value, :string
      add :category, :string

      timestamps()
    end

  end
end
