defmodule RestfulApiWeb.RoleController do
  use RestfulApiWeb, :controller

  alias RestfulApi.Authentication
  alias RestfulApi.Authentication.Role

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, _params) do
    roles = Authentication.list_roles()
    render(conn, "index.json", roles: roles)
  end

  def create(conn, %{"role" => role_params}) do
    with {:ok, %Role{} = role} <- Authentication.create_role(role_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", role_path(conn, :show, role))
      |> render("show.json", role: role)
    end
  end

  def show(conn, %{"id" => id}) do
    role = Authentication.get_role!(id)
    render(conn, "show.json", role: role)
  end

  def update(conn, %{"id" => id, "role" => role_params}) do
    role = Authentication.get_role!(id)

    with {:ok, %Role{} = role} <- Authentication.update_role(role, role_params) do
      render(conn, "show.json", role: role)
    end
  end

  def delete(conn, %{"id" => id}) do
    role = Authentication.get_role!(id)
    with {:ok, %Role{}} <- Authentication.delete_role(role) do
      send_resp(conn, :no_content, "")
    end
  end
end
