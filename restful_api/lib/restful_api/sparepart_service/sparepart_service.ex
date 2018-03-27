defmodule RestfulApi.SparepartService do
  import Ecto.Query, warn: false
  use RestfulApi.BaseContext
  alias RestfulApi.SparepartService.Sparepart

  defmacro __using__(_opts) do
    quote do
      import RestfulApi.SparepartService
      use RestfulApi.BaseContext
      alias RestfulApi.SparepartService.Sparepart
    end
  end

  def page(params, conn) do 
    Sparepart
    |> query_like(params, "name")
    |> query_like(params, "attributes")
    |> query_like(params, "specifications")
    |> query_order_by(params, "name")
    |> get_pagination(params, conn)
  end
end
