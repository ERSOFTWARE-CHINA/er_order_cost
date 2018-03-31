defmodule RestfulApiWeb.StaffController do
  use RestfulApiWeb, :controller
  use RestfulApi.StaffService
  import RestfulApiWeb.Plugs.Auth, only: [auth_root: 2]
  alias RestfulApi.StaffService.Staff

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, params) do
    page = page(params, conn)
    render(conn, "index.json", page: page)
  end

  def create(conn, %{"staff" => staff_params}) do
    with {:ok, %Staff{} = staff} <- save_create(Staff.changeset(%Staff{}, staff_params), conn) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", staff_path(conn, :show, staff))
      |> render("show.json", staff: staff)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, staff} <- get_by_id(Staff, id, conn) do
      render(conn, "show.json", staff: staff)
    end
  end

  def update(conn, %{"id" => id, "staff" => staff_params}) do
    with {:ok, staff} <- get_by_id(Staff, id, conn) do
      with {:ok, %Staff{} = staff} <- save_update(Staff.changeset(staff, staff_params), conn) do
        render(conn, "show.json", staff: staff)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Staff{} = staff} <- delete_by_id(Staff, id, conn) do
      render(conn, "show.json", staff: staff)
    end
  end

  def check_jobnumber(conn, %{"id"=> id,"job_number" => job_number}) do
    case check_job_number_exists(%{"id"=> String.to_integer(id),"job_number" => job_number}) do
      {:ok, _} -> json conn, %{ok: "job_number ok"}
      {:error, _} ->
        json conn, %{error: "job_number error"}
    end
  end

end
