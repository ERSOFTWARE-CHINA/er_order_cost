defmodule RestfulApi.Repo.Migrations.CreateStaffs do
  use Ecto.Migration

  def change do
    create table(:staffs) do
      add :job_number, :string
      add :name, :string
      add :sex, :string
      add :age, :integer
      add :project_id, references(:projects)
      timestamps()
    end

  end
end
