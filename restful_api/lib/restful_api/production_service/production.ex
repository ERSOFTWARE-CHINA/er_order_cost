defmodule RestfulApi.ProductionService.Production do
  use Ecto.Schema
  import Ecto.Changeset


  schema "productions" do
    field :attributes, :string
    field :name, :string
    field :specifications, :string

    belongs_to :project, RestfulApi.Tenant.Project

    timestamps()
  end

  @doc false
  def changeset(production, attrs) do
    production
    |> cast(attrs, [:name, :attributes, :specifications])
    |> validate_required([:name])
  end
end
