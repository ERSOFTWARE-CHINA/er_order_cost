defmodule RestfulApiWeb.PurchaseController do
  use RestfulApiWeb, :controller

  alias RestfulApi.PurchaseService
  alias RestfulApi.PurchaseService.Purchase

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, _params) do
    perchases = PurchaseService.list_perchases()
    render(conn, "index.json", perchases: perchases)
  end

  def create(conn, %{"purchase" => purchase_params}) do
    with {:ok, %Purchase{} = purchase} <- PurchaseService.create_purchase(purchase_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", purchase_path(conn, :show, purchase))
      |> render("show.json", purchase: purchase)
    end
  end

  def show(conn, %{"id" => id}) do
    purchase = PurchaseService.get_purchase!(id)
    render(conn, "show.json", purchase: purchase)
  end

  def update(conn, %{"id" => id, "purchase" => purchase_params}) do
    purchase = PurchaseService.get_purchase!(id)

    with {:ok, %Purchase{} = purchase} <- PurchaseService.update_purchase(purchase, purchase_params) do
      render(conn, "show.json", purchase: purchase)
    end
  end

  def delete(conn, %{"id" => id}) do
    purchase = PurchaseService.get_purchase!(id)
    with {:ok, %Purchase{}} <- PurchaseService.delete_purchase(purchase) do
      send_resp(conn, :no_content, "")
    end
  end
end
