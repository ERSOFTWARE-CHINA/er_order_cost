defmodule RestfulApi.ProductionStockinService do
  @moduledoc """
  产品入库单Service
  """
  import Ecto.Query, warn: false
  use RestfulApi.BaseContext
  alias RestfulApi.ProductionStockinService.ProductionStockin

  defmacro __using__(_opts) do
    quote do
      import RestfulApi.ProductionStockinService
      use RestfulApi.BaseContext
      alias RestfulApi.ProductionStockinService.ProductionStockin
    end
  end

  def page(params, conn) do 
    ProductionStockin
    |> query_like(params, "no")
    |> query_equal(params, "production_id")
    |> query_order_desc_by(params, "inserted_at")
    |> get_pagination(params, conn)
  end
  
end
