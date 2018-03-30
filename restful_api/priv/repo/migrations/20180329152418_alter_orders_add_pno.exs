defmodule RestfulApi.Repo.Migrations.AlterOrdersAddPno do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :pno, :string, null: false
    end
  end
end
