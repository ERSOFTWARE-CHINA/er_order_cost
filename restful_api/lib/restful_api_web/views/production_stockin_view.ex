defmodule RestfulApiWeb.ProductionStockinView do
  use RestfulApiWeb, :view
  alias RestfulApiWeb.ProductionStockinView

  def render("index.json", %{page: page}) do
    %{
      data: render_many(page.entries, ProductionStockinView, "production_stockin.json"),
      page_number: page.page_number,
      page_size: page.page_size,
      total_entries: page.total_entries,
      total_pages: page.total_pages
    }
  end

  def render("show.json", %{production_stockin: production_stockin}) do
    %{data: render_one(production_stockin, ProductionStockinView, "production_stockin.json")}
  end

  def render("production_stockin.json", %{production_stockin: production_stockin}) do
    %{
      id: production_stockin.id,
      no: production_stockin.no,
      amount: production_stockin.amount,
      date: production_stockin.date,
      unit: production_stockin.unit,
      remark: production_stockin.remark,
      order: production_stockin.order,
      production: production_stockin.production,

    }
  end
end
