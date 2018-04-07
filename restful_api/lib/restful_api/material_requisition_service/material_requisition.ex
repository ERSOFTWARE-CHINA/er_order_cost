defmodule RestfulApi.MaterialRequisitionService.MaterialRequisition do
  use Ecto.Schema
  import Ecto.Changeset
  alias RestfulApi.MaterialRequisitionService.MaterialRequisitionDetail
  alias RestfulApi.Tenant.Project
  alias RestfulApi.OrderService.Order


  schema "material_requisitions" do
    field :no,     :string
    field :picker, :string
    # field :price,  :float
    field :date,   :date
    field :remark, :string

    has_many   :details, MaterialRequisitionDetail, on_delete: :delete_all, on_replace: :delete
    belongs_to :project, Project,                   on_replace: :nilify
    belongs_to :order,   Order,                     on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(material_requisition, attrs) do
    material_requisition
    |> cast(attrs, [:no, :date, :remark, :picker])
    |> validate_required([:no, :date, :picker])
  end
end
