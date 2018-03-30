defmodule RestfulApi.ProductionStockinService.ProductionStockin do
  use Ecto.Schema
  import Ecto.Changeset
  alias RestfulApi.Tenant.Project
  alias RestfulApi.OrderService.Order
  alias RestfulApi.ProductionService.Production


  schema "production_stockins" do
    field :no,      :string
    field :amount,  :integer
    field :date,    :date      
    field :remark,  :string  
    field :unit,    :string  

    belongs_to :production,  Production,  on_replace: :nilify
    belongs_to :project,     Project,     on_replace: :nilify
    belongs_to :order,       Order,       on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(production_stockin, attrs) do
    production_stockin
    |> cast(attrs, [:no,:amount,:date,:remark,:unit])
    |> validate_required([:no,:amount,:date])
  end
end
