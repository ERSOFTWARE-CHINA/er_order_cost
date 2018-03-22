defmodule RestfulApi.Repo.Migrations.AlterProjectSetPermsNumberToBigint do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      modify :perms_number, :bigint
    end
  end
end
