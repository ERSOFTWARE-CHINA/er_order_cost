defmodule RestfulApiWeb.SparepartStockController do
  @moduledoc """
  配件库存controller
  """
  use RestfulApiWeb, :controller
  use RestfulApi.SparepartStockService
  import RestfulApiWeb.Plugs.Auth, only: [project_active: 2]

  plug :project_active

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, params) do
    page = page(params, conn)
    render(conn, "index.json", page: page)
  end

end
