defmodule RestfulApiWeb.SparepartController do
  use RestfulApiWeb, :controller

  alias RestfulApi.SparepartService
  alias RestfulApi.SparepartService.Sparepart

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, _params) do
    spareparts = SparepartService.list_spareparts()
    render(conn, "index.json", spareparts: spareparts)
  end

  def create(conn, %{"sparepart" => sparepart_params}) do
    with {:ok, %Sparepart{} = sparepart} <- SparepartService.create_sparepart(sparepart_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", sparepart_path(conn, :show, sparepart))
      |> render("show.json", sparepart: sparepart)
    end
  end

  def show(conn, %{"id" => id}) do
    sparepart = SparepartService.get_sparepart!(id)
    render(conn, "show.json", sparepart: sparepart)
  end

  def update(conn, %{"id" => id, "sparepart" => sparepart_params}) do
    sparepart = SparepartService.get_sparepart!(id)

    with {:ok, %Sparepart{} = sparepart} <- SparepartService.update_sparepart(sparepart, sparepart_params) do
      render(conn, "show.json", sparepart: sparepart)
    end
  end

  def delete(conn, %{"id" => id}) do
    sparepart = SparepartService.get_sparepart!(id)
    with {:ok, %Sparepart{}} <- SparepartService.delete_sparepart(sparepart) do
      send_resp(conn, :no_content, "")
    end
  end
end
