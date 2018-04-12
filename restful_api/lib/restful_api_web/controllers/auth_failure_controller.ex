defmodule RestfulApiWeb.AuthFailureController do
  use RestfulApiWeb, :controller
  import RestfulApiWeb.TranslateMsg

  def plug_auth_failure(conn, %{"msg" => msg}) do
    json conn , %{error: ~t/#{msg}/}
  end
end