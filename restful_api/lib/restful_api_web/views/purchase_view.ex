defmodule RestfulApiWeb.PurchaseView do
  use RestfulApiWeb, :view
  alias RestfulApiWeb.PurchaseView

  def render("index.json", %{perchases: perchases}) do
    %{data: render_many(perchases, PurchaseView, "purchase.json")}
  end

  def render("show.json", %{purchase: purchase}) do
    %{data: render_one(purchase, PurchaseView, "purchase.json")}
  end

  def render("purchase.json", %{purchase: purchase}) do
    %{id: purchase.id,
      pno: purchase.pno}
  end
end
