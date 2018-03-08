defmodule RestfulApiWeb.RoleController do
  use RestfulApiWeb, :controller
  use RestfulApi.Authentication
  import RestfulApiWeb.Permissions, only: [need_perms: 1]
  alias Guardian.Permissions.Bitwise

  plug Bitwise,  need_perms([:write_role]) when action in [:update, :delete, :create]
  plug Bitwise,  need_perms([:read_role]) when action in [:index, :show]

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, params) do
    page = page(params)
    render(conn, "index.json", page: page)
  end

  def create(conn, %{"role" => role_params}) do
    with {:ok, %Role{} = role} <- save_create(Role, role_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", role_path(conn, :show, role))
      |> render("show.json", role: role)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, role} <- get_by_id(Role, id) do
      render(conn, "show.json", role: role)
    end
  end

  def update(conn, %{"id" => id, "role" => role_params}) do
    with {:ok, %Role{} = role} <- save_update(Role, id, role_params) do
      render(conn, "show.json", role: role)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Role{} = role} <- delete_by_id(Role, id) do
      render(conn, "show.json", role: role)
    end
  end
end
