defmodule RestfulApi.SparepartService.Sparepart do
  use Ecto.Schema
  import Ecto.Changeset


  schema "spareparts" do
    field :attributes, :string
    field :name, :string
    field :specifications, :string

    timestamps()
  end

  @doc false
  def changeset(sparepart, attrs) do
    sparepart
    |> cast(attrs, [:name, :attributes, :specifications])
    |> validate_required([:name, :attributes, :specifications])
  end
end
