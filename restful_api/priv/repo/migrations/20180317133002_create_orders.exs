defmodule RestfulApi.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :name, :string
      add :project_id, references(:projects, on_delete: :nothing)

      timestamps()
    end

    create index(:orders, [:project_id])
  end
end
