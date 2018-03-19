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
        IO.puts("@@@@@login ok@@@@@")
        {:ok, token, claims} = RestfulApiWeb.Guardian.encode_and_sign(user, %{pem: %{"default" => user.perms_number}, project: proj})
        perms = Permissions.get_permissions(claims)
        json conn, %{user: get_user_map(user), jwt: token, perms: perms}
      {:error, _} ->
        IO.puts("@@@@@login error@@@@@")
        conn
        |> put_status(200)
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
          # 用户存在，且不为root，但用户未激活
          !is_nil(user) && !user.is_root && !user.actived ->
            IO.puts("error in first condition")
            {:error, nil}
          # 用户存在，且不为root，但项目已禁用
          !is_nil(user) && !user.is_root && !project.actived ->
            {:error, nil}
          # 用户存在，且密码正确
          !is_nil(user) && Comeonin.Pbkdf2.checkpw(password, user.password_hash) ->
            {:ok, user}
          true ->
            IO.puts("error in secend condition")
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