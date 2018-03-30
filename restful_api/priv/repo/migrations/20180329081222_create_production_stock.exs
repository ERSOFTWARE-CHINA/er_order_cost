defmodule RestfulApi.Repo.Migrations.CreateProductionStock do
  use Ecto.Migration

  def change do
    create table(:production_stocks) do
      add :no, :string, null: false
      add :amount, :integer, null: false
      add :unit, :string
      add :status, :boolean, null: false

      add :project_id, references(:projects)
      add :production_id, references(:productions)

      timestamps()
    end
  end
end
