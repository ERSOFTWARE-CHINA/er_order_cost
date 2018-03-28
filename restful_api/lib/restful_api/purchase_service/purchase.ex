defmodule RestfulApi.PurchaseService.Purchase do
  use Ecto.Schema
  import Ecto.Changeset

  alias RestfulApi.PurchaseService.PurchaseDetail
  alias RestfulApi.OrderService.Order
  alias RestfulApi.Tenant.Project


  schema "purchases" do
    field :pno,    :string   # 采购单号
    field :price,  :float     # 采购单价格
    field :date,   :date      # 采购日期
    field :remark, :string      # 备注
    has_many :details, PurchaseDetail, on_delete: :delete_all, on_replace: :delete
    belongs_to :order, Order, on_replace: :nilify
    belongs_to :project, Project, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(purchase, attrs) do
    purchase
    |> cast(attrs, [:pno, :price, :date, :remark])
    |> validate_required([:pno, :price, :date])
  end
end
