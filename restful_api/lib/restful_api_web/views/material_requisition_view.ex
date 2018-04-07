defmodule RestfulApiWeb.MaterialRequisitionView do
  use RestfulApiWeb, :view
  alias RestfulApiWeb.MaterialRequisitionView

  def render("index.json", %{page: page}) do
    %{
      data: render_many(page.entries, MaterialRequisitionView, "material_requisition.json"),
      page_number: page.page_number,
      page_size: page.page_size,
      total_entries: page.total_entries,
      total_pages: page.total_pages
    }
  end

  def render("show.json", %{material_requisition: material_requisition}) do
    %{data: render_one(material_requisition, MaterialRequisitionView, "material_requisition.json")}
  end

  def render("material_requisition.json", %{material_requisition: material_requisition}) do
    %{
      id: material_requisition.id,
      no: material_requisition.no,
      picker: material_requisition.picker,
      date: material_requisition.date,
      remark: material_requisition.remark,
      order_id: material_requisition.order_id,
      details: material_requisition.details,
      order: material_requisition.order,
    }
  end
end
