defmodule RestfulApiWeb.ProductionController do
  use RestfulApiWeb, :controller
  use RestfulApi.ProductionService
  import RestfulApiWeb.Plugs.Auth, only: [auth_root: 2]
  alias RestfulApi.ProductionService.Production

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, params) do
    page = page(params, conn)
    render(conn, "index.json", page: page)
  end

  def create(conn, %{"production" => production_params}) do
    with {:ok, %Production{} = production} <- save_create(Production.changeset(%Production{}, production_params), conn) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", production_path(conn, :show, production))
      |> render("show.json", production: production)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, production} <- get_by_id(Production, id, conn) do
      render(conn, "show.json", production: production)
    end
  end

  def update(conn, %{"id" => id, "production" => production_params}) do
    with {:ok, production} <- get_by_id(Production, id, conn) do
      with {:ok, %Production{} = production} <- save_update(Production.changeset(production, production_params), conn) do
        render(conn, "show.json", production: production)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Production{} = production} <- delete_by_id(Production, id, conn) do
      render(conn, "show.json", production: production)
    end
  end


end
