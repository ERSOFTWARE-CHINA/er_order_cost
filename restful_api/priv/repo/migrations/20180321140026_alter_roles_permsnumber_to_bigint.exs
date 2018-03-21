defmodule RestfulApi.Repo.Migrations.AlterRolesPermsnumberToBigint do
  use Ecto.Migration

  def change do
    alter table(:roles) do
      modify :perms_number, :bigint
    end
  end
end
