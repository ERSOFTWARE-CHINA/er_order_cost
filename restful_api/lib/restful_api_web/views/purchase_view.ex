defmodule RestfulApiWeb.PurchaseView do
  use RestfulApiWeb, :view
  alias RestfulApiWeb.PurchaseView

  def render("index.json", %{page: page}) do
    %{
      data: render_many(page.entries, PurchaseView, "purchase.json"),
      page_number: page.page_number,
      page_size: page.page_size,
      total_entries: page.total_entries,
      total_pages: page.total_pages
    }
  end

  def render("show.json", %{purchase: purchase}) do
    %{data: render_one(purchase, PurchaseView, "purchase.json")}
  end

  def render("purchase.json", %{purchase: purchase}) do
    %{
      id: purchase.id,
      pno: purchase.pno,
      price: purchase.price,
      date: purchase.date,
      remark: purchase.remark,
      order_id: purchase.order_id,

      details: purchase.details,
      order: purchase.order,
    }
  end
end
