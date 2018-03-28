defmodule RestfulApi.PurchaseService do

  import Ecto.Query, warn: false
  use RestfulApi.BaseContext
  alias RestfulApi.PurchaseService.Purchase

  defmacro __using__(_opts) do
    quote do
      import RestfulApi.PurchaseService
      use RestfulApi.BaseContext
      alias RestfulApi.PurchaseService.Purchase
      alias RestfulApi.PurchaseService.PurchaseDetail
    end
  end

  def page(params, conn) do 
    Purchase
    |> query_like(params, "pno")
    |> query_like(params, "remark")
    |> query_equal(params, "order_id")
    |> query_order_by(params, "date")
    |> get_pagination(params, conn)
  end
end