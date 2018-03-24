defmodule RestfulApiWeb.ProductionView do
  use RestfulApiWeb, :view
  alias RestfulApiWeb.ProductionView

  def render("index.json", %{prodctions: prodctions}) do
    %{data: render_many(prodctions, ProductionView, "production.json")}
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
