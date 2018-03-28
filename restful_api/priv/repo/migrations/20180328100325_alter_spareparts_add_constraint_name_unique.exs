defmodule RestfulApi.Repo.Migrations.AlterSparepartsAddConstraintNameUnique do
  use Ecto.Migration

  def change do
    create unique_index(:spareparts, [:name])
  end
end
