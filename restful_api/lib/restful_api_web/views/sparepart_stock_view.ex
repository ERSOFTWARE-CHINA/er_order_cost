defmodule RestfulApiWeb.SparepartStockView do
  use RestfulApiWeb, :view
  alias RestfulApiWeb.SparepartStockView

  def render("index.json", %{page: page}) do
    %{
      data: render_many(page.entries, SparepartStockView, "sparepart_stock.json"),
      page_number: page.page_number,
      page_size: page.page_size,
      total_entries: page.total_entries,
      total_pages: page.total_pages
    }
  end

  def render("sparepart_stock.json", %{sparepart_stock: sparepart_stock}) do
    %{
      id: sparepart_stock.id,
      no: sparepart_stock.no,
      id: sparepart_stock.amount,
      no: sparepart_stock.unit,
      no: sparepart_stock.status
    }
  end
end
