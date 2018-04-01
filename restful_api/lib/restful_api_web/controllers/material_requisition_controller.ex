defmodule RestfulApiWeb.MaterialRequisitionController do
  use RestfulApiWeb, :controller

  use RestfulApi.MaterialRequisitionService
  alias RestfulApi.OrderService.Order
  alias RestfulApi.SparepartService.Sparepart

  import RestfulApiWeb.Plugs.Auth, only: [project_active: 2]

  plug :project_active

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, params) do
    page = page(params, conn)
    render(conn, "index.json", page: page)
  end

  def create(conn, %{"material_requisition" => material_requisition_params}) do
    order_changset = get_order_changeset(material_requisition_params, conn)
    details_changeset = get_details_changesets(material_requisition_params, conn)
    mr_changeset = MaterialRequisition.changeset(%MaterialRequisition{}, material_requisition_params)
    |> Ecto.Changeset.put_assoc(:order, order_changset)
    |> Ecto.Changeset.put_assoc(:details, details_changeset)
    with {:ok, %MaterialRequisition{} = mr} <- save_create(mr_changeset, conn) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", material_requisition_path(conn, :show, mr))
      |> render("show.json", material_requisition: mr)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, mr} <- get_by_id(MaterialRequisition, id, conn, [details: [:sparepart]]) do
      render(conn, "show.json", material_requisition: mr)
    end
  end

  def update(conn, %{"id" => id, "material_requisition" => material_requisition_params}) do
    with {:ok, mr} <- get_by_id(MaterialRequisition, id, conn, [:order, :details,:project]) do
      order_changset = get_order_changeset(material_requisition_params, conn)
      details_changeset = get_details_changesets(material_requisition_params, conn)
      mr_changeset = MaterialRequisition.changeset(mr, material_requisition_params)
      |> Ecto.Changeset.put_assoc(:order, order_changset)
      |> Ecto.Changeset.put_assoc(:details, details_changeset)
      with {:ok, %MaterialRequisition{} = mr} <- save_update(mr_changeset, conn) do
        render(conn, "show.json", material_requisition: mr)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %MaterialRequisition{} = mr} <- delete_by_id(MaterialRequisition, id, conn) do
      render(conn, "show.json", material_requisition: mr)
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

  defp get_details_changesets(params, conn) do
    params
    |> Map.get("details", [])
    |> Enum.map(fn(d)->
      sparepart_changeset = d |> get_sparepart_changeset(conn)
      MaterialRequisitionDetail.changeset(%MaterialRequisitionDetail{}, d)
      |> Ecto.Changeset.put_assoc(:sparepart, sparepart_changeset)
    end)
  end

  defp get_sparepart_changeset(detail_param, conn) do
    detail_param
    |> Map.get("sparepart", %{})
    |> Map.get("name")
    |> case do
      nil -> nil
      name ->
        case get_by_name(Sparepart, conn, name: name) do
          {:error, _} -> nil
          {:ok, sparepart} -> change(Sparepart, sparepart)
        end
    end
  end
end
