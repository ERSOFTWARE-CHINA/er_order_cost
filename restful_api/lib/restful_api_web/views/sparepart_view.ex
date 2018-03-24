defmodule RestfulApiWeb.SparepartView do
  use RestfulApiWeb, :view
  alias RestfulApiWeb.SparepartView

  def render("index.json", %{spareparts: spareparts}) do
    %{data: render_many(spareparts, SparepartView, "sparepart.json")}
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
