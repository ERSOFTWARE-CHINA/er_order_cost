defmodule RestfulApi.Tenant.Project do
  use Ecto.Schema
  import Ecto.Changeset


  schema "projects" do
    field :name, :string
    field :actived, :boolean, default: false
    field :deadline, :string
    field :perms_number, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :actived, :deadline, :perms_number])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, min: 4)
    |> validate_required([:actived])
  end
end
