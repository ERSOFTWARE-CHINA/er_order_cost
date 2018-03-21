defmodule RestfulApiWeb.RoleController do
  use RestfulApiWeb, :controller
  use RestfulApi.Authentication
  import RestfulApiWeb.Permissions, only: [need_perms: 1, get_all_permissions: 0, get_max_perms_number: 0]
  alias Guardian.Permissions.Bitwise

  import RestfulApiWeb.Plugs.Auth, only: [project_active: 2, auth_admin: 2]

  plug :project_active
  plug :auth_admin

  # plug Bitwise,  need_perms([:write_role]) when action in [:update, :delete, :create]
  # plug Bitwise,  need_perms([:read_role]) when action in [:index, :show]

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, params) do
    page = page(params, conn)
    render(conn, "index.json", page: page)
  end

  def create(conn, %{"role" => role_params}) do
    with {:ok, %Role{} = role} <- save_create(Role.changeset(%Role{}, role_params), conn) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", role_path(conn, :show, role))
      |> render("show.json", role: role)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, role} <- get_by_id(Role, id, conn) do
      render(conn, "show.json", role: role)
    end
  end

  def update(conn, %{"id" => id, "role" => role_params}) do
    with {:ok, role} <- get_by_id(Role, id, conn, [:project]) do
      with {:ok, %Role{} = role} <- save_update(Role.changeset(role, role_params), conn) do
        render(conn, "show.json", role: role)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Role{} = role} <- delete_by_id(Role, id, conn) do
      render(conn, "show.json", role: role)
    end
  end

  def list_all_perms(conn, _) do
    json conn, get_all_permissions
  end
end
