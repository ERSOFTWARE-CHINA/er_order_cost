defmodule RestfulApiWeb.ProjectUserController do
  use RestfulApiWeb, :controller
  use RestfulApi.Accounts
  alias RestfulApi.Authentication.Role
  alias RestfulApi.Tenant.Project

  import RestfulApiWeb.Plugs.Auth, only: [auth_root: 2]

  plug :auth_root

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, params) do
    page = page(params, conn)
    render(conn, "index.json", page: page)
  end

  def create(conn, %{"user" => user_params}) do
    role_changsets = roles_exists(user_params, conn)
    project_changeset = get_project_changeset(user_params, conn) 
    user_changeset = User.changeset(%User{}, user_params)
    user_changeset = Ecto.Changeset.put_assoc(user_changeset, :roles, role_changsets)
    user_changeset = Ecto.Changeset.put_assoc(user_changeset, :project, project_changeset)
    with {:ok, %User{} = user} <- save_create(user_changeset, conn) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", project_user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- get_by_id(User, id, conn, [:project, :roles]) do
      render(conn, "show.json", project_user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    with {:ok, user} <- get_by_id(User, id, conn, [:project, :roles]) do
      role_changsets = roles_exists(user_params, conn)
      user_changeset = User.changeset(user, user_params)
      user_changeset = Ecto.Changeset.put_assoc(user_changeset, :roles, role_changsets)
      with {:ok, %User{} = user} <- save_update(user_changeset, conn) do
        render(conn, "show.json", project_user: user)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- delete_by_id(User, id, conn) do
      render(conn, "show.json", project_user: user)
    end
  end

  defp get_project_changeset(user_params, conn) do
    user_params
    |> Map.get("project", %{})
    |> Map.get("id")
    |> case do
      nil -> nil
      id ->
        case get_by_id(Project, id, conn) do
          {:error, _} -> nil
          {:ok, proj} -> change(Project, proj)
        end
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

  def check_email(conn, %{"email" => email}) do
    case get_by_name(User, conn, email: email) do
      nil -> json conn, %{ok: "email ok"}
      _ -> json conn, %{error: "email error"}
    end
  end

  # 根据参数中的id获取roles，将自动忽略错误的参数
  defp roles_exists(params, conn) do
    roles = params
    |> Map.get("roles", []) 
    |> Enum.filter(fn(r)-> match?(%{"id" => id}, r) end)
    |> Enum.map(fn(r) -> 
      with %{"id" => id} <- r do
        case get_by_id(Role, id, conn) do
          {:error, _} -> nil
          {:ok, role} -> change(Role, role)
        end
      end
    end)
    |> Enum.filter(fn(r)-> !is_nil(r) end)
  end

  defp project_exists(id, conn) do
    case get_by_id(Project, id, conn) do
      nil -> nil
      project -> change(Project, project)
    end
  end



end
