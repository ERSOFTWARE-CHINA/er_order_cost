defmodule RestfulApi.OrderService do
  import Ecto.Query, warn: false
  use RestfulApi.BaseContext
  alias RestfulApi.OrderService.Order

  defmacro __using__(_opts) do
    quote do
      import RestfulApi.OrderService
      use RestfulApi.BaseContext
      alias RestfulApi.OrderService.Order
    end
  end

  def page(params, conn) do 
    Order
    |> query_like(params, "name")
    |> query_order_by(params, "name")
    |> get_pagination(params, conn)
  end
end
