defmodule RestfulApiWeb.ContsView do
  use RestfulApiWeb, :view
  alias RestfulApiWeb.ContsView

  def render("index.json", %{conts: conts}) do
    %{data: render_many(conts, ContsView, "conts.json")}
  end

  def render("show.json", %{conts: conts}) do
    %{data: render_one(conts, ContsView, "conts.json")}
  end

  def render("conts.json", %{conts: conts}) do
    %{id: conts.id,
      name: conts.name,
      value: conts.value,
      category: conts.category}
  end
end
