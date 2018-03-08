defmodule RestfulApiWeb.LoginController do
    
  use RestfulApiWeb, :controller   
  alias RestfulApiWeb.{Guardian, Permissions}
#   import RestfulApiWeb.TranslateError
  use Ecto.Schema

  use RestfulApi.Accounts
      
  def login(conn, params) do
    %{"password" => pw, "username" => un} = params
    case checkPassword(un, pw) do
      {:ok, user} ->
        {:ok, token, claims} = RestfulApiWeb.Guardian.encode_and_sign(user, %{pem: %{"default" => user.perms_number}})
        perms = Permissions.get_permissions(claims)
        json conn, %{user: get_user_map(user), jwt: token, perms: perms}
      {:error, _} ->
        conn
        |> put_status(401)
        |> json %{error: "invalid login!"}
    end
  end

  defp checkPassword(username, password) do

    user = get_by_name(User, name: username)

    cond do
      # 用户存在，且密码正确
      user && Comeonin.Pbkdf2.checkpw(password, user.password_hash) ->
        {:ok, user}
      true ->
        {:error, nil}
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