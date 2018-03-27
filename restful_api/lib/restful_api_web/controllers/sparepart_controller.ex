defmodule RestfulApiWeb.SparepartController do
  use RestfulApiWeb, :controller
  use RestfulApi.SparepartService
  alias RestfulApi.SparepartService
  alias RestfulApi.SparepartService.Sparepart
  import RestfulApiWeb.Plugs.Auth, only: [project_active: 2]

  plug :project_active

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, params) do
    page = page(params, conn)
    render(conn, "index.json", page: page)
  end

  def create(conn, %{"sparepart" => sparepart_params}) do
    with {:ok, %Sparepart{} = sparepart} <- save_create(Sparepart.changeset(%Sparepart{}, sparepart_params), conn) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", sparepart_path(conn, :show, sparepart))
      |> render("show.json", sparepart: sparepart)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, sparepart} <- get_by_id(Sparepart, id, conn) do
      render(conn, "show.json", sparepart: sparepart)
    end
  end

  def update(conn, %{"id" => id, "sparepart" => sparepart_params}) do
    with {:ok, sparepart} <- get_by_id(Sparepart, id, conn, [:project]) do
      with {:ok, %Sparepart{} = sparepart} <- save_update(Sparepart.changeset(sparepart, sparepart_params), conn) do
        render(conn, "show.json", sparepart: sparepart)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Sparepart{} = sparepart} <- delete_by_id(Sparepart, id, conn) do
      render(conn, "show.json", sparepart: sparepart)
    end
  end
end
