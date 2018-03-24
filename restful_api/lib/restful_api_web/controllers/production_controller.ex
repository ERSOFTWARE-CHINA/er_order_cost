defmodule RestfulApiWeb.ProductionController do
  use RestfulApiWeb, :controller

  alias RestfulApi.ProductionService
  alias RestfulApi.ProductionService.Production

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, _params) do
    prodctions = ProductionService.list_prodctions()
    render(conn, "index.json", prodctions: prodctions)
  end

  def create(conn, %{"production" => production_params}) do
    with {:ok, %Production{} = production} <- ProductionService.create_production(production_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", production_path(conn, :show, production))
      |> render("show.json", production: production)
    end
  end

  def show(conn, %{"id" => id}) do
    production = ProductionService.get_production!(id)
    render(conn, "show.json", production: production)
  end

  def update(conn, %{"id" => id, "production" => production_params}) do
    production = ProductionService.get_production!(id)

    with {:ok, %Production{} = production} <- ProductionService.update_production(production, production_params) do
      render(conn, "show.json", production: production)
    end
  end

  def delete(conn, %{"id" => id}) do
    production = ProductionService.get_production!(id)
    with {:ok, %Production{}} <- ProductionService.delete_production(production) do
      send_resp(conn, :no_content, "")
    end
  end
end
