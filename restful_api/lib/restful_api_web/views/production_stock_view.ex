defmodule RestfulApiWeb.ProductionStockView do
  use RestfulApiWeb, :view
  alias RestfulApiWeb.ProductionStockView

  def render("index.json", %{page: page}) do
    %{
      data: render_many(page.entries, ProductionStockView, "production_stock.json"),
      page_number: page.page_number,
      page_size: page.page_size,
      total_entries: page.total_entries,
      total_pages: page.total_pages
    }
  end

  def render("production_stock.json", %{production_stock: production_stock}) do
    %{
      id: production_stock.id,
      no: production_stock.no,
      amount: production_stock.amount,
      unit: production_stock.unit,
      status: production_stock.status,
      inserted_at: production_stock.inserted_at
    }
  end
end
