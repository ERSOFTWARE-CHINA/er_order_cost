defmodule RestfulApi.Authentication.Role do
  use Ecto.Schema
  import Ecto.Changeset


  schema "roles" do
    field :name, :string
    field :perms, :integer, default: 0
    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :perms])
    |> validate_required([:name, :perms])
    |> unique_constraint(:rolename)
    |> validate_length(:name, min: 2)
  end
end
