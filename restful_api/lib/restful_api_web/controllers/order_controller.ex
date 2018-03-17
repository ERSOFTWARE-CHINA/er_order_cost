defmodule RestfulApiWeb.OrderController do
  use RestfulApiWeb, :controller

  alias RestfulApi.OrderService
  alias RestfulApi.OrderService.Order

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, _params) do
    orders = OrderService.list_orders()
    render(conn, "index.json", orders: orders)
  end

  def create(conn, %{"order" => order_params}) do
    with {:ok, %Order{} = order} <- OrderService.create_order(order_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", order_path(conn, :show, order))
      |> render("show.json", order: order)
    end
  end

  def show(conn, %{"id" => id}) do
    order = OrderService.get_order!(id)
    render(conn, "show.json", order: order)
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    order = OrderService.get_order!(id)

    with {:ok, %Order{} = order} <- OrderService.update_order(order, order_params) do
      render(conn, "show.json", order: order)
    end
  end

  def delete(conn, %{"id" => id}) do
    order = OrderService.get_order!(id)
    with {:ok, %Order{}} <- OrderService.delete_order(order) do
      send_resp(conn, :no_content, "")
    end
  end
end
