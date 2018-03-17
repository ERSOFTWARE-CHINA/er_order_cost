defmodule RestfulApiWeb.ProjectController do
  use RestfulApiWeb, :controller

  alias RestfulApi.Tenant
  alias RestfulApi.Tenant.Project

  import RestfulApiWeb.Plugs.Auth, only: [auth_root: 2]

  plug :auth_root

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, _params) do
    projects = Tenant.list_projects()
    render(conn, "index.json", projects: projects)
  end

  def create(conn, %{"project" => project_params}) do
    with {:ok, %Project{} = project} <- Tenant.create_project(project_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", project_path(conn, :show, project))
      |> render("show.json", project: project)
    end
  end

  def show(conn, %{"id" => id}) do
    project = Tenant.get_project!(id)
    render(conn, "show.json", project: project)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Tenant.get_project!(id)

    with {:ok, %Project{} = project} <- Tenant.update_project(project, project_params) do
      render(conn, "show.json", project: project)
    end
  end

  def delete(conn, %{"id" => id}) do
    project = Tenant.get_project!(id)
    with {:ok, %Project{}} <- Tenant.delete_project(project) do
      send_resp(conn, :no_content, "")
    end
  end
end
