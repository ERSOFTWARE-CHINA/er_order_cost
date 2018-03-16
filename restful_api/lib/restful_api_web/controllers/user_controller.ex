defmodule RestfulApiWeb.UserController do
  use RestfulApiWeb, :controller
  use RestfulApi.Accounts
  alias RestfulApi.Authentication.Role

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, params) do
    page = page(params)
    render(conn, "index.json", page: page)
  end

  def create(conn, %{"user" => user_params}) do
    role_changsets = roles_exists(user_params)
    user_changeset = User.changeset(%User{}, user_params)
    user_changeset = Ecto.Changeset.put_assoc(user_changeset, :roles, role_changsets)
    with {:ok, %User{} = user} <- save_create(user_changeset) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- get_by_id(User, id, [:organization, :roles]) do
      render(conn, "show.json", user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    with {:ok, user} <- get_by_id(User, id, [:organization, :roles]) do
      role_changsets = roles_exists(user_params)
      user_changeset = User.changeset(user, user_params)
      user_changeset = Ecto.Changeset.put_assoc(user_changeset, :roles, role_changsets)
      with {:ok, %User{} = user} <- save_update(user_changeset) do
        render(conn, "show.json", user: user)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- delete_by_id(User, id) do
      render(conn, "show.json", user: user)
    end
  end

  def check_name(conn, %{"name" => name}) do
    case get_by_name(User, name: name) do
      nil -> json conn, %{ok: "name ok"}
      _ -> json conn, %{error: "name error"}
    end
  end

  def check_email(conn, %{"email" => email}) do
    case get_by_name(User, email: email) do
      nil -> json conn, %{ok: "email ok"}
      _ -> json conn, %{error: "email error"}
    end
  end

  # 根据参数中的id获取roles，将自动忽略错误的参数
  defp roles_exists(params) do
    roles = params
    |> Map.get("roles", []) 
    |> Enum.filter(fn(r)-> match?(%{"id" => id}, r) end)
    |> Enum.map(fn(r) -> 
      with %{"id" => id} <- r do
        case get_by_id(Role, id) do
          {:error, _} -> nil
          {:ok, role} -> change(Role, role)
        end
      end
    end)
    |> Enum.filter(fn(r)-> !is_nil(r) end)
  end

end
