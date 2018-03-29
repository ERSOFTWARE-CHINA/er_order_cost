defmodule RestfulApi.SparepartStockService.SparepartStock do
  use Ecto.Schema
  import Ecto.Changeset

  alias RestfulApi.Tenant.Project
  alias RestfulApi.SparepartService.Sparepart

  schema "sparepart_stocks" do
    field :no,      :string      # 采购单号
    field :amount,  :integer     # 数量
    field :unit,    :string      # 单位
    field :status,  :boolean     # 状态
    belongs_to :sparepart, Sparepart, on_replace: :nilify
    belongs_to :project, Project, on_replace: :nilify
    timestamps()
  end

  @doc false
  def changeset(spstock, attrs) do
    spstock
    |> cast(attrs, [:no,:amount,:unit,:status])
    |> validate_required([:no,:amount,:status])
  end
end
