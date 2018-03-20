defmodule RestfulApiWeb.UserController do
  use RestfulApiWeb, :controller
  use RestfulApi.Accounts
  alias RestfulApi.Authentication.Role
  alias RestfulApi.Authentication.Role

  import RestfulApiWeb.Plugs.Auth, only: [project_active: 2, auth_root: 2, auth_admin: 2]

  plug :project_active
  plug :auth_admin
  plug :auth_root when action in [:assign_to_project] 

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, params) do
    page = page(params, conn)
    render(conn, "index.json", page: page)
  end

  def create(conn, %{"user" => user_params}) do
    role_changsets = roles_exists(user_params, conn)
    user_changeset = User.changeset(%User{}, user_params)
    IO.puts inspect user_changeset
    user_changeset = Ecto.Changeset.put_assoc(user_changeset, :roles, role_changsets)
    with {:ok, %User{} = user} <- save_create(user_changeset, conn) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- get_by_id(User, id, conn, [:organization, :roles]) do
      render(conn, "show.json", user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    with {:ok, user} <- get_by_id(User, id, conn, [:organization, :roles]) do
      role_changsets = roles_exists(user_params, conn)
      user_changeset = User.changeset(user, user_params)
      user_changeset = Ecto.Changeset.put_assoc(user_changeset, :roles, role_changsets)
      with {:ok, %User{} = user} <- save_update(user_changeset, conn) do
        render(conn, "show.json", user: user)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- delete_by_id(User, id, conn) do
      render(conn, "show.json", user: user)
    end
  end

  def assign_to_project(conn, %{"id" => id, "project_id" => project_id}) do
    with {:ok, user} <- get_by_id(User, id, conn, [:project]) do
      project_changset = project_exists(project_id, conn)
      user_changeset = change(User, user)
      user_changeset = Ecto.Changeset.put_assoc(user_changeset, :project, project_changset)
      with {:ok, %User{} = user} <- save_update(user_changeset, conn) do
        render(conn, "show.json", user: user)
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
