defmodule RestfulApi.MaterialRequisitionService do
  @moduledoc """
  The MaterialRequisitionService context.
  """

  import Ecto.Query, warn: false
  use RestfulApi.BaseContext
  alias RestfulApi.MaterialRequisitionService.MaterialRequisition

  defmacro __using__(_opts) do
    quote do
      import RestfulApi.MaterialRequisitionService
      use RestfulApi.BaseContext
      alias RestfulApi.MaterialRequisitionService.MaterialRequisition
      alias RestfulApi.MaterialRequisitionService.MaterialRequisitionDetail
    end
  end

  def page(params, conn) do 
    MaterialRequisition
    |> query_like(params, "no")
    |> query_like(params, "remark")
    |> query_equal(params, "order_id")
    |> query_order_by(params, "date")
    |> get_pagination(params, conn)
  end
end
