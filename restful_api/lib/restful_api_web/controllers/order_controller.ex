defmodule RestfulApiWeb.OrderController do
  use RestfulApiWeb, :controller

  use RestfulApi.OrderService
  alias RestfulApi.OrderService.Order
  alias RestfulApi.OrderService.OrderDetail
  alias RestfulApi.ProductionService.Production
  import RestfulApiWeb.Plugs.Auth, only: [project_active: 2]

  plug :project_active

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, params) do
    page = page(params, conn)
    render(conn, "index.json", page: page)
  end

  def create(conn, %{"order" => order_params}) do
    details_changeset = get_details_changesets(order_params, conn)
    order_changeset = Order.changeset(%Order{}, order_params)
    |> Ecto.Changeset.put_assoc(:details, details_changeset)
    with {:ok, %Order{} = order} <- save_create(order_changeset, conn) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", order_path(conn, :show, order))
      |> render("show.json", order: order)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, order} <- get_by_id(Order, id, conn, [details: [:production]]) do
      render(conn, "show.json", order: order)
    end
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    with {:ok, order} <- get_by_id(Order, id, conn, [:details,:project]) do
      details_changeset = get_details_changesets(order_params, conn)
      order_changeset = Order.changeset(order, order_params)
      |> Ecto.Changeset.put_assoc(:details, details_changeset)
      with {:ok, %Order{} = order} <- save_update(order_changeset, conn) do
        render(conn, "show.json", order: order)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Order{} = order} <- delete_by_id(Order, id, conn) do
      render(conn, "show.json", order: order)
    end
  end

  defp get_details_changesets(order_params, conn) do
    order_params
    |> Map.get("details", [])
    |> Enum.map(fn(d)->
      production_changeset = d |> get_production_changeset(conn)
      OrderDetail.changeset(%OrderDetail{}, d)
      |> Ecto.Changeset.put_assoc(:production, production_changeset)
    end)
  end

  defp get_production_changeset(detail_param, conn) do
    detail_param
    |> Map.get("production", %{})
    |> Map.get("name")
    |> case do
      nil -> nil
      name ->
        case get_by_name(Production, conn, name: name) do
          {:error, _} -> nil
          {:ok, production} -> change(Production, production)
        end
    end
  end
end
