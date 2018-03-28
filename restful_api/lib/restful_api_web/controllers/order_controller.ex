defmodule RestfulApiWeb.OrderController do
  use RestfulApiWeb, :controller

  use RestfulApi.OrderService
  alias RestfulApi.OrderService
  alias RestfulApi.OrderService.Order
  import RestfulApiWeb.Permissions, only: [need_perms: 1]
  import RestfulApiWeb.Plugs.Auth, only: [project_active: 2]

  plug :project_active

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, params) do
    page = page(params, conn)
    render(conn, "index.json", page: page)
  end

  def create(conn, %{"order" => order_params}) do
    with {:ok, %Order{} = order} <- save_create(Order.changeset(%Order{}, order_params), conn) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", order_path(conn, :show, order))
      |> render("show.json", order: order)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, order} <- get_by_id(Order, id, conn) do
      render(conn, "show.json", order: order)
    end
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    with {:ok, order} <- get_by_id(Order, id, conn) do
      with {:ok, %Order{} = order} <- save_update(Order.changeset(order, order_params), conn) do
        render(conn, "show.json", order: order)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Order{} = order} <- delete_by_id(Order, id, conn) do
      render(conn, "show.json", order: order)
    end
  end
end
