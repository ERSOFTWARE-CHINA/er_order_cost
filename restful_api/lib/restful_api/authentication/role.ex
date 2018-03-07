defmodule RestfulApi.Authentication.Role do
  use Ecto.Schema
  import Ecto.Changeset


  schema "roles" do
    field :name, :string
    field :perms_number, :integer, default: 0
    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :perms_number])
    |> validate_required([:name, :perms_number])
    |> unique_constraint(:name)
    |> validate_length(:name, min: 2)
  end
end
