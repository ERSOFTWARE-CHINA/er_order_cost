defmodule RestfulApi.Repo.Migrations.CreateProductionStockins do
  use Ecto.Migration

  def change do
    create table(:production_stockins) do
      add :no, :string, null: false
      add :amount, :integer, null: false
      add :unit, :string
      add :date, :date, null: false
      add :remark, :text
      add :order_id, references(:orders)
      add :project_id, references(:projects)
      add :production_id, references(:productions)

      timestamps()
    end

    create unique_index(:production_stockins, [:no])

  end
end
