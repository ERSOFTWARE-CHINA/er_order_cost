defmodule RestfulApiWeb.ProjectController do
  use RestfulApiWeb, :controller
  use RestfulApi.Tenant

  import RestfulApiWeb.Plugs.Auth, only: [auth_root: 2]

  plug :auth_root

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, params) do
    page = page(params, conn)
    render(conn, "index.json", page: page)
  end

  def create(conn, %{"project" => project_params}) do
    with {:ok, %Project{} = project} <- save_create(Project.changeset(%Project{}, project_params), conn) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", project_path(conn, :show, project))
      |> render("show.json", project: project)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, project} <- get_by_id(Project, id, conn) do
      render(conn, "show.json", project: project)
    end
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    with {:ok, project} <- get_by_id(Project, id, conn) do
      with {:ok, %Project{} = proj} <- save_update(Project.changeset(project, project_params), conn) do
        render(conn, "show.json", project: proj)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Project{} = project} <- delete_by_id(Project, id, conn) do
      render(conn, "show.json", project: project)
    end
  end

  # get请求中的参数为字符串类型，这里需要将id转换微integer类型，因此前台需传送数字，否则报错
  def check_name(conn, %{"id"=> id,"name" => name}) do
    case check_name_exists(%{"id"=> String.to_integer(id),"name" => name}) do
      {:ok, _} -> json conn, %{ok: "name ok"}
      {:error, _} -> 
        json conn, %{error: "name error"}
    end
  end
end
