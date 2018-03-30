defmodule RestfulApi.Repo.Migrations.CreateSparepartStock do
  use Ecto.Migration

  def change do
    create table(:sparepart_stocks) do
      add :no, :string, null: false
      add :amount, :integer, null: false
      add :unit, :string
      add :status, :boolean, null: false

      add :project_id, references(:projects)
      add :sparepart_id, references(:spareparts)

      timestamps()
    end
  end
end
