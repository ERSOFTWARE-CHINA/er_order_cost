defmodule RestfulApiWeb.ProductionStockController do
  @moduledoc """
  产品库存controller
  """
  use RestfulApiWeb, :controller
  use RestfulApi.ProductionStockService
  import RestfulApiWeb.Plugs.Auth, only: [project_active: 2]

  plug :project_active

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, params) do
    page = page(params, conn)
    render(conn, "index.json", page: page)
  end

end
