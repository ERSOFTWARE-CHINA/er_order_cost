defmodule RestfulApiWeb.SparepartView do
  use RestfulApiWeb, :view
  alias RestfulApiWeb.SparepartView

  def render("index.json", %{page: page}) do
    %{
      data: render_many(page.entries, SparepartView, "sparepart.json"),
      page_number: page.page_number,
      page_size: page.page_size,
      total_entries: page.total_entries,
      total_pages: page.total_pages
    }
  end

  def render("show.json", %{sparepart: sparepart}) do
    %{data: render_one(sparepart, SparepartView, "sparepart.json")}
  end

  def render("sparepart.json", %{sparepart: sparepart}) do
    %{id: sparepart.id,
      name: sparepart.name,
      attributes: sparepart.attributes,
      specifications: sparepart.specifications}
  end
end
