defmodule RestfulApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :password_hash, :string, null: false
      add :email, :string, null: false
      add :real_name, :string
      add :position, :string
      add :is_admin, :boolean, null: false
      add :perms_number, :integer, null: false
      add :actived, :Boolean, null: false
      add :avatar, :string
      timestamps()
    end

    create unique_index(:users, [:name])
    create unique_index(:users, [:email])

  end
end
