defmodule RestfulApi.Conts.Model.Conts do
  use Ecto.Schema
  import Ecto.Changeset


  schema "conts" do
    field :category, :string
    field :name, :string
    field :value, :string

    timestamps()
  end

  @doc false
  def changeset(conts, attrs) do
    conts
    |> cast(attrs, [:name, :value, :category])
    |> validate_required([:name, :value, :category])
  end
end
