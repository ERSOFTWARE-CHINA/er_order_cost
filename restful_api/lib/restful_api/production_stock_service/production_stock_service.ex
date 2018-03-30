defmodule RestfulApi.ProductionStockService do
  import Ecto.Query, warn: false
  use RestfulApi.BaseContext
  alias RestfulApi.ProductionStockService.ProductionStock

  defmacro __using__(_opts) do
    quote do
      import RestfulApi.ProductionStockService
      use RestfulApi.BaseContext
      alias RestfulApi.ProductionStockService.ProductionStock
    end
  end

  def page(params, conn) do 
    ProductionStock
    |> query_like(params, "no")
    |> query_equal(params, "status")
    |> query_equal(params, "production_id")
    |> query_order_desc_by(params, "inserted_at")
    |> get_pagination(params, conn)
  end
end
