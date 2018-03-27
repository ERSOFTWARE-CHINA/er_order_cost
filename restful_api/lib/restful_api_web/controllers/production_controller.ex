defmodule RestfulApiWeb.ProductionController do
  use RestfulApiWeb, :controller
  import RestfulApi.ProductionService
  import RestfulApiWeb.Plugs.Auth, only: [auth_root: 2]
  import RestfulApiWeb.Permissions
  alias RestfulApi.ProductionService.Production

  plug :auth_root

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, params) do
    page = page(params, conn)
    render(conn, "index.json", page: page)
  end

end
