defmodule RestfulApiWeb.AuthErrorHandler do
  import Plug.Conn
  # import RestfulApiWeb.TranslateError, only: [translate_msg: 1]

  def auth_error(conn, {type, _}, _opts) do
    body = Poison.encode!(%{message: "Invalid login!"})
    send_resp(conn, 401, body)
  end
end