defmodule RestfulApi.Repo.Migrations.AlterPurchasesColumnPnoToString do
  use Ecto.Migration

  def change do
    alter table(:purchases) do
      modify :pno, :string
    end
  end
end
