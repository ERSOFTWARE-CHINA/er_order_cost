defmodule RestfulApiWeb.PurchaseController do
  use RestfulApiWeb, :controller

  use RestfulApi.PurchaseService
  alias RestfulApi.PurchaseService.Purchase
  alias RestfulApi.OrderService.Order
  alias RestfulApi.SparepartService.Sparepart

  import RestfulApiWeb.Plugs.Auth, only: [project_active: 2, auth_root: 2, auth_admin: 2]

  plug :project_active

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, params) do
    page = page(params, conn)
    render(conn, "index.json", page: page)
  end

  def create(conn, %{"purchase" => purchase_params}) do
    order_changset = get_order_changeset(purchase_params, conn)
    details_changeset = get_details_changesets(purchase_params, conn)
    purchase_changeset = Purchase.changeset(%Purchase{}, purchase_params)
    |> Ecto.Changeset.put_assoc(:order, order_changset)
    |> Ecto.Changeset.put_assoc(:details, details_changeset)
    with {:ok, %Purchase{} = purchase} <- save_create(purchase_changeset, conn) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", purchase_path(conn, :show, purchase))
      |> render("show.json", purchase: purchase)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, purchase} <- get_by_id(Purchase, id, conn, [:details, :order]) do
      render(conn, "show.json", purchase: purchase)
    end
  end

  def update(conn, %{"id" => id, "purchase" => purchase_params}) do
    with {:ok, purchase} <- get_by_id(Purchase, id, conn, [:order, :details]) do
      order_changset = get_order_changeset(purchase_params, conn)
      details_changeset = get_details_changesets(purchase_params, conn)
      purchase_changeset = Purchase.changeset(purchase, purchase_params)
      |> Ecto.Changeset.put_assoc(:order, order_changset)
      |> Ecto.Changeset.put_assoc(:details, details_changeset)
      with {:ok, %Purchase{} = purchase} <- save_update(purchase_changeset, conn) do
        render(conn, "show.json", purchase: purchase)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Purchase{} = purchase} <- delete_by_id(Purchase, id, conn) do
      render(conn, "show.json", purchase: purchase)
    end
  end

  defp get_order_changeset(purchase_params, conn) do
    purchase_params
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

  defp get_details_changesets(purchase_params, conn) do
    purchase_params
    |> Map.get("details", [])
    |> Enum.map(fn(d)->
      PurchaseDetail.changeset(%PurchaseDetail{}, d)
    end)
  end

  defp get_sparepart_changeset(detail_params, conn) do
    detail_params
    |> Map.get("sparepart", %{})
    |> Map.get("id")
    |> case do
      nil -> nil
      id ->
        case get_by_id(Sparepart, id, conn) do
          {:error, _} -> nil
          {:ok, sparepart} -> change(Sparepart, sparepart)
        end
    end
  end
end
