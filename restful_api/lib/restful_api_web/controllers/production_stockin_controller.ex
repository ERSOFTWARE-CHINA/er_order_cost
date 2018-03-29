defmodule RestfulApiWeb.ProductionStockinController do
  use RestfulApiWeb, :controller

  use RestfulApi.ProductionStockinService
  alias RestfulApi.ProductionService.Production
  alias RestfulApi.OrderService.Order

  import RestfulApiWeb.Plugs.Auth, only: [project_active: 2]

  plug :project_active

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, params) do
    page = page(params, conn)
    render(conn, "index.json", page: page)
  end

  def create(conn, %{"production_stockin" => params}) do
    order_changset = get_order_changeset(params, conn)
    prod_changeset = get_production_changeset(params, conn)
    prodstockin_changeset = ProductionStockin.changeset(%ProductionStockin{}, params)
    |> Ecto.Changeset.put_assoc(:order, order_changset)
    |> Ecto.Changeset.put_assoc(:production, prod_changeset)
    with {:ok, %ProductionStockin{} = prodstockin} <- save_create(prodstockin_changeset, conn) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", production_stockin_path(conn, :show, prodstockin))
      |> render("show.json", production_stockin: prodstockin)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, prodstockin} <- get_by_id(ProductionStockin, id, conn, [:order, :production]) do
      render(conn, "show.json", production_stockin: prodstockin)
    end
  end

  def update(conn, %{"id" => id, "production_stockin" => params}) do
    with {:ok, prodstockin} <- get_by_id(ProductionStockin, id, conn, [:order, :details,:project]) do
      order_changset = get_order_changeset(params, conn)
      prod_changeset = get_production_changeset(params, conn)
      prodstockin_changeset = ProductionStockin.changeset(prodstockin, params)
      |> Ecto.Changeset.put_assoc(:order, order_changset)
      |> Ecto.Changeset.put_assoc(:production, prod_changeset)
      with {:ok, %ProductionStockin{} = prodstockin} <- save_update(prodstockin_changeset, conn) do
        render(conn, "show.json", production_stockin: prodstockin)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %ProductionStockin{} = prodstockin} <- delete_by_id(ProductionStockin, id, conn) do
      render(conn, "show.json", production_stockin: prodstockin)
    end
  end

  defp get_order_changeset(params, conn) do
    params
    |> Map.get("order", %{})
    |> Map.get("id")
    |> case do
      nil -> nil
      id ->
        case get_by_id(Order, id, conn) do
          {:error, _} -> nil
          {:ok, order} -> change(Order, order)
        end
    end
  end

  defp get_production_changeset(param, conn) do
    param
    |> Map.get("production", %{})
    |> Map.get("id")
    |> case do
      nil -> nil
      id ->
        case get_by_id(Production, id, conn) do
          {:error, _} -> nil
          {:ok, prod} -> change(Production, prod)
        end
    end
  end
end
