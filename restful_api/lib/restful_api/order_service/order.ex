defmodule RestfulApi.OrderService.Order do
  use Ecto.Schema
  import Ecto.Changeset

  import RestfulApi.Tenant.Project


  schema "orders" do
    field :name, :string
    belongs_to :project, Project, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:name,:project_id])
    |> validate_required([:name,:project_id])
  end
end
