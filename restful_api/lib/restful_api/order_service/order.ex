defmodule RestfulApi.OrderService.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias RestfulApi.Tenant.Project
  alias RestfulApi.OrderService.OrderDetail

  schema "orders" do
    field :name, :string     #订单名称
    field :pno,    :string   # 订单号
    field :price,  :float     # 订单价格
    field :date,   :date      # 日期
    field :remark, :string      # 备注
    has_many :details, OrderDetail, on_delete: :delete_all, on_replace: :delete

    belongs_to :project, Project, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:name,:pno,:date])
    |> validate_required([:name,:pno])
  end
end
