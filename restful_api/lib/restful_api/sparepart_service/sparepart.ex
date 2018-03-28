defmodule RestfulApi.SparepartService.Sparepart do
  use Ecto.Schema
  import Ecto.Changeset
  alias RestfulApi.Tenant.Project


  schema "spareparts" do
    field :attributes, :string
    field :name, :string
    field :specifications, :string

    belongs_to :project, Project, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(sparepart, attrs) do
    sparepart
    |> cast(attrs, [:name, :attributes, :specifications])
    |> validate_required([:name, :attributes, :specifications])
    |> unique_constraint(:name)
  end
end
