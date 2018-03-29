defmodule RestfulApi.SparepartStockService do
  import Ecto.Query, warn: false
  use RestfulApi.BaseContext
  alias RestfulApi.SparepartStockService.SparepartStock

  defmacro __using__(_opts) do
    quote do
      import RestfulApi.SparepartStockService
      use RestfulApi.BaseContext
      alias RestfulApi.SparepartStockService.SparepartStock
    end
  end

  def page(params, conn) do 
    SparepartStock
    |> query_like(params, "no")
    |> query_equal(params, "status")
    |> query_equal(params, "sparepart_id")
    |> query_order_desc_by(params, "inserted_at")
    |> get_pagination(params, conn)
  end
end
