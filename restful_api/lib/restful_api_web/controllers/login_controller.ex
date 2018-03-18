defmodule RestfulApiWeb.LoginController do
    
  use RestfulApiWeb, :controller   
  alias RestfulApiWeb.{Guardian, Permissions}
#   import RestfulApiWeb.TranslateError
  use Ecto.Schema

  alias RestfulApi.Accounts.User
  alias RestfulApi.Tenant.Project
  alias RestfulApi.Repo

      
  def login(conn, %{"password" => pw, "username" => un, "project" => proj} = params) do
    case checkPassword(un, pw, proj) do
      {:ok, user} ->
        {:ok, token, claims} = RestfulApiWeb.Guardian.encode_and_sign(user, %{pem: %{"default" => user.perms_number}, project: proj})
        perms = Permissions.get_permissions(claims)
        json conn, %{user: get_user_map(user), jwt: token, perms: perms}
      {:error, _} ->
        conn
        |> put_status(401)
        |> json(%{error: "Invalid username or password!"})
    end
  end

  defp checkPassword(username, password, project) do
    Project
    |> Repo.get_by(name: project)
    |> case do
      nil -> {:error, nil}
      project -> 
        user = Repo.get_by(User, %{ name: username, project_id: project.id })

        cond do
          # 用户存在，且密码正确
          user && Comeonin.Pbkdf2.checkpw(password, user.password_hash) ->
            {:ok, user}
          true ->
            {:error, nil}
        end
    end
    
  end

  defp get_user_map(user) do
    case user do
      nil -> nil
      user ->
        %{
          id: user.id,
          name: user.name,
          email: user.email,
          real_name: user.real_name,
          position: user.position,
          is_admin: user.is_admin,
          actived: user.actived,
          perms_number: user.perms_number,
          avatar: user.avatar,
          roles: user.roles,
          organization: user.organization
        }
    end
  end

end