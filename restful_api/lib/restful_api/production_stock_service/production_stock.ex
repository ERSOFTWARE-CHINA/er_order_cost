defmodule RestfulApi.ProductionStockService.ProductionStock do
  use Ecto.Schema
  import Ecto.Changeset

  alias RestfulApi.Tenant.Project
  alias RestfulApi.ProductionService.Production

  schema "production_stock" do
    field :no,      :string      # 产品入库单号
    field :amount,  :integer     # 数量
    field :unit,    :string      # 单位
    field :status,  :boolean     # 状态
    belongs_to :production, Production, on_replace: :nilify
    belongs_to :project, Project, on_replace: :nilify
    timestamps()
  end

  @doc false
  def changeset(prodstock, attrs) do
    prodstock
    |> cast(attrs, [:no,:amount,:unit,:status])
    |> validate_required([:no,:amount,:status])
  end
end
