defmodule RestfulApi.ProductionService.Production do
  use Ecto.Schema
  import Ecto.Changeset

  import RestfulApi.Tenant.Project

  schema "prodctions" do
    field :attributes, :string
    field :name, :string
    field :specifications, :string
    belongs_to :project, Project, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(production, attrs) do
    production
    |> cast(attrs, [:name, :attributes, :specifications,:project])
    |> validate_required([:name,:project])
  end
end
