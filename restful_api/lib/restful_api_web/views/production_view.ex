defmodule RestfulApiWeb.ProductionView do
  use RestfulApiWeb, :view
  alias RestfulApiWeb.ProductionView


  def render("index.json", %{page: page}) do
    %{
      data: render_many(page.entries, ProductionView, "production.json"),
      page_number: page.page_number,
      page_size: page.page_size,
      total_entries: page.total_entries,
      total_pages: page.total_pages
    }
  end

  def render("show.json", %{production: production}) do
    %{data: render_one(production, ProductionView, "production.json")}
  end

  def render("production.json", %{production: production}) do
    %{id: production.id,
      name: production.name,
      attributes: production.attributes,
      specifications: production.specifications}
  end
end
