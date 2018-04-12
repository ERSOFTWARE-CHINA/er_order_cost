defmodule RestfulApiWeb.AuthErrorHandler do
  import Plug.Conn
  import RestfulApiWeb.TranslateMsg

  def auth_error(conn, {type, _}, _opts) do
    body = Poison.encode!(%{error: ~t/invalid token info./})
    send_resp(conn, 401, body)
  end
end